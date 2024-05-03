# Setup fzf on osx
# ---------
if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"

  # Auto-completion
  # ---------------
  [[ $- == *i* ]] && source "/opt/homebrew/opt/fzf/shell/completion.zsh" 2> /dev/null

  # Key bindings
  # ------------
  source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh"
fi

# Setup fzf on linux via git install
if [[ ! "$PATH" == */home/$USER/.fzf/bin* ]]; then
    PATH="${PATH:+${PATH}:}/home/$USER/.fzf/bin"
    eval "$(fzf --zsh)"
fi

