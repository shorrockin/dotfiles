alias l='ls'     
alias ll='ls -lha'

alias vim='nvim -p'
alias vi='nvim -p'

alias ts='tmux-sessionizer'
alias slack-format="pbpaste | ~/.zsh/scripts/slack-thread-format | pbcopy"

alias ..='cd ../'
alias dots='cd ~/dotfiles'

gsub() {
  ack -l ${1} | xargs sed -i '' "s/${1}/${2}/g"
}

lines() {
  more ${1} | nl -ba
}

simple-server() {
python -m "SimpleHTTPServer"
}

go-test() {
go test $@ $(go list ./...  | grep -v /vendor/)
for pkg in $(go list ./... |grep -v /vendor/)
do
  golint $pkg
done
}

go-delete-test-files() {
find . -name "*.test" -type f -delete
}

to-big-emoji() {
if (( $# == 0 )) ; then
  sed -E "s/([A-Z'a-z])/:big-\1:/g" < /dev/stdin
else
  sed -E "s/([A-Z'a-z])/:big-\1:/g" <<< "$@"
fi
}

list-sleep-events() {
pmset -g log | grep "Wake Requests" | tail -n 20
}
