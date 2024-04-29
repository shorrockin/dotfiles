# -----------------------------------------------
# Set up the Environment
# -----------------------------------------------
EDITOR=vim
PAGER=less
RSYNC_RSH=/usr/bin/ssh
PATH=./bin:./node_modules/.bin:.:$PATH:~/.zsh/scripts
HISTFILE=~/.zshhistory
HISTSIZE=3000
SAVEHIST=3000

# Enable vi mode
bindkey -v

export LESS="-RFX"

export TERM EDITOR PAGER RSYNC_RSH CVSROOT FIGNORE DISPLAY NNTPSERVER PATH HISTFILE HISTSIZE SAVEHIST
