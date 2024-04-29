# -----------------------------------------------
# Set up the prompt and plugins via oh-my-zsh
# -----------------------------------------------
ZSH=$HOME/.oh-my-zsh
DEFAULT_USER=chris
ZSH_THEME="powerlevel10k/powerlevel10k"
DISABLE_AUTO_TITLE="true"

source $ZSH/oh-my-zsh.sh
# source $ZSH/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(zsh-vi-mode git)

DISABLE_CORRECTION="true"
unsetopt correct
unsetopt correct_all
unsetopt auto_cd
