docker-clean() {
    docker rm `docker ps --no-trunc -aq`
    docker images | grep "<none>" | awk '{print $3}' | xargs docker rmi
}

docker-kill-all() {
    echo "Killing: `docker ps -q --no-trunc`"
    docker kill `docker ps -q --no-trunc`
    killall -9 bash
    killall -9 fswatch
}

docker-volume-clean() {
    docker volume rm $(docker volume ls -qf dangling=true)
}

docker-shell() {
    docker run --rm -it $1 /bin/sh
}

docker-bash() {
    docker run --rm -it $1 /bin/bash
}


docker-attach() {
    docker exec -it $1 /bin/bash
}

dct() {
    docker-compose -f docker-composes.test.yml $@
}

docker-stats() {
    docker stats $(docker ps --format '{{.Names}}')
}

docker-restore-db() {
    echo "This method expects the contain id as the first param, and the"
    echo "database name as the second param, and the backup script location"
    echo "as the third parameter. It assumes the DB name, Username and"
    echo "password are all the same (for docker db instances)."
    echo ""
    echo "Container id: $1"
    echo "Database: $2"
    echo "Backup File: $3"
    echo ""

    if [ "$#" -ne 3 ]; then
        echo "illegal number of parameters, expected 3 had $#"
    else
        echo "[1] copying $3 to docker container $1"
        docker cp $3 $1:/tmp/backup.sql

        echo "[2] terminating all connections to database"
        docker exec -it $1 psql -U $2 -c "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE datname = current_database() AND pid <> pg_backend_pid();"

        echo "[3] dropping database"
        docker exec -it $1 psql -U $2 -d postgres -c "DROP DATABASE $2;"

        echo "[4] creating database"
        docker exec -it $1 psql -U $2 -d postgres -c "CREATE DATABASE $2;"

        echo "[5] importing script"
        docker exec -it $1 psql -d $2 -U $2 -f /tmp/backup.sql
    fi

}

alias dc='docker-compose'
alias d='docker'
alias dka='docker-kill-all'
