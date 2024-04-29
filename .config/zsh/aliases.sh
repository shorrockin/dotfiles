## Command Aliases
alias vim='nvim -p'
alias vi='nvim -p'
alias l='ls -lFh'     #size,show type,human readable
alias ll='ls -lFha'
alias la='ls -lAFh'   #long list,show almost all,show type,human readable
alias lt='ls -ltFh'   #long list,sorted by date,show type,human readable
alias ts='tmux-sessionizer'
alias e='emacs'
alias cat='bat'
alias more='bat'
alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'
alias slack-format="pbpaste | ~/.zsh/scripts/slack-thread-format | pbcopy"

h() {
    local selected_command="$(history | awk '{$1=""; gsub(/\\n/, " ", $0); $0=$0; if (!seen[$0]++) print}' | fzf --no-sort --tac --exact)" 
    if [ -n "$selected_command" ]; then  
        print -s -- "$selected_command"  
        eval "$selected_command"  
    fi  
}

hc() {
    history | awk '{$1=""; gsub(/\\n/, " ", $0); $0=$0; if (!seen[$0]++) print}' | fzf --no-sort --tac --exact | pbcopy
}
 
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
