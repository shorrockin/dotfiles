# on linux, use batcat instead of bat
[[ ! -f /usr/bin/batcat ]] || alias bat='batcat'

# alias ls to eza, which is a nicer ls. 
# https://github.com/eza-community/eza
if command -v /opt/homebrew/bin/eza >/dev/null 2>&1; then
  alias ls="eza --icons=always"
fi

## other common aliases
alias vim='nvim -p'
alias vi='nvim -p'
alias l='ls -lh'     #size,show type,human readable
alias ll='ls -lha'
alias ts='tmux-sessionizer'
alias e='emacs'
alias cat='bat'
alias more='bat'
alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'
alias slack-format="pbpaste | ~/.zsh/scripts/slack-thread-format | pbcopy"

gsub() {
 ack -l ${1} | xargs sed -i '' "s/${1}/${2}/g"
}

lines() {
  more ${1} | nl -ba
}

export RIPPER_TAGS_EMACS=1
tags-generate() {
  ctags -a -e -f TAGS --tag-relative -R $@
}

tags-ruby-generate() {
  find . -name "*.rb" -print | etags -
}

tags-ruby-regenerate() {
  ripper-tags -R -f TAGS
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
