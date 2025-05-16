# these are better placed in the .gitignore file
# alias ga='git add'
# alias gf='git fetch'
# alias gl='git-log'
alias gs='git status'
alias gd='git diff'
# alias gm='git mergetool'
# alias gam='git add --all . && git add -u . && git commit -am'
# alias gamnv='git add --all . && git add -u . && git commit --no-verify -am'
# alias gb='git branch'
# alias gco='git checkout'
# alias gra='git remote add'
# alias grr='git remote rm'
# alias gcl='git clone'
# alias gp='git pull'
# alias glb='git-log-branch'
# alias git-amend='git commit --amend'
# alias git-undo='git reset --soft HEAD^'
alias g='git'
alias pre-commit=".git/hooks/pre-commit"

function git-branch-name {
  git rev-parse --abbrev-ref HEAD
}

function gpom {
  git pull origin $(git-branch-name)
}

function gpr {
  git pull --rebase origin $(git-branch-name)
}

function gpsh {
  git push origin $(git-branch-name)
}

function gpshf {
  git push origin $(git-branch-name) --force
}

gsp() function {
  git stash && git pull --rebase origin $(git-branch-name) && git stash apply
}

function git-merge-deploy-master-push {
    g co deploy
    git merge master
    gpsh
    g co master
    gpsh
}

function git-log {
  git log --graph --pretty=format:'%an: %s - %Cred%h%Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative $1
}

function git-delete-remote-tag {
  git push origin :refs/tags/$0
}

function git-restore-to-head {
  git cat-file -p HEAD:$1 > $1
}

function git-branch {
  git checkout -b $1
  git push --set-upstream origin $1
}

function git-branch-other {
    git fetch origin +$1:$1
    g co $1
}

function git-remember-password {
    git config credential.helper store
    ssh-add ~/.ssh/id_rsa
}

function git-track {
  CURRENT_BRANCH=$(git-branch-name)
  git config branch.$CURRENT_BRANCH.remote $1
  git config branch.$CURRENT_BRANCH.merge refs/heads/$CURRENT_BRANCH
}

function git-fix {
  AUTOSQUASH_AT=$(git log --format=format:%H $1^1 -1)
  git add --all . && git add -u . && git commit -a --no-verify --fixup $1 
  git rebase -i --autosquash $AUTOSQUASH_AT
}

function git-fix-file {
  AUTOSQUASH_AT=$(git log --format=format:%H $1^1 -1)
  git add $2 && git commit --no-verify --fixup $1
  git stash 
  git rebase -i --autosquash $AUTOSQUASH_AT
  git stash apply
}

function git-clean {
    CURRENT_BRANCH=$(git-branch-name)

    # Make sure we're working with the most up-to-date version of master.
    git fetch

    # garbage collect
    git gc

    # Prune obsolete remote tracking branches. These are branches that we
    # once tracked, but have since been deleted on the remote.
    git remote prune origin

    # List all the branches that have been merged fully into master, and
    # then delete them. We use the remote master here, just in case our
    # local master is out of date.
    git branch --merged origin/master | grep -v 'master$' | grep -v 'master-passing-tests$' | xargs git branch -d

    # git-delete-squashed: https://github.com/not-an-aardvark/git-delete-squashed
    git checkout -q master && git for-each-ref refs/heads/ "--format=%(refname:short)" | while read branch; do mergeBase=$(git merge-base master $branch) && [[ $(git cherry master $(git commit-tree $(git rev-parse $branch^{tree}) -p $mergeBase -m _)) == "-"* ]] && git branch -D $branch; done

    # clean up loose ends
    git prune

    # go back to hte branch we started on
    git checkout $CURRENT_BRANCH
}

function git-log-branch {
  git log --reverse --pretty=format:'%an: %s - %Cred%h%Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative $(git-branch-name)...master-passing-tests $1
}

function git-emoji {
    echo "🎨 :art: when improving the format/structure of the code"
    echo "🚀 :rocket: when improving performance"
    echo "📝 :memo: when writing docs"
    echo "💡 :bulb: new idea"
    echo "🚧 :construction: work in progress"
    echo "👍 :thumbsup: when adding feature"
    echo "👎 :thumbsdown: when removing feature"
    echo "🔈 :speaker: when adding logging"
    echo "🔇 :mute: when reducing logging"
    echo "🐛 :bug: when fixing a bug"
    echo "✅ :white_check_mark: when adding tests"
    echo "💚 :green_heart: fixing tests / continuous integration"
    echo "🔒 :lock: when dealing with security"
    echo "⬆️ :arrow_up: when adding / upgrading dependencies"
    echo "⬇️ :arrow_down: when downgrading dependencies"
}

git config --global color.ui true
