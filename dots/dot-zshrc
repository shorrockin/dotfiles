# "autoload" is a zsh built-in command which marks functions or scripts to be loaded and executed later when they are first used.
# The "-U" flag ensures that there is only one copy of the function, regardless of how often it is autoloaded.
# The "+X" flag allows loading functions from the FPATH even if they do not have the execute permission.

# Here, bashcompinit is autoloaded, and then called if it successfully autoloads.
# bashcompinit is a function that can be used in Zsh to load and use Bash completions.
autoload -U +X bashcompinit && bashcompinit

# Next, compinit is autoloaded, and then called if it successfully autoloads.
# compinit is a function that initializes and loads Zsh completions. It searches in $fpath for completion definitions and keeps the compiled function in a dump file.
autoload -U +X compinit && compinit

# This line calls compinit function again, this may not be necessary if the previous compinit execution was successful.
compinit

# only if we have a .bash_profile, then load it up
[[ ! -f ~/.bash_profile ]] || source ~/.bash_profile

# enables vim-esque bindings for editing the current command
# must be before the fzf bindings for the ** completions to work on
# things like kil, cd, etc
set -o vi

# load everything in this directory, we git stow a bunch of different .sh files here 
# for both work and personal projects (separate git repos)
for file in ~/.config/zsh/*.sh
do
    source "$file"
done

# loads nvm if it exists and/is necessary
[ -s $HOME/.nvm/nvm.sh ] && . $HOME/.nvm/nvm.sh 

# only ad go the path if it exists
if command -v go >/dev/null 2>&1; then
  export PATH="${PATH}:$(go env GOPATH)/bin"
fi

# directory containing custom scripts across our different git stow'd repos
export PATH="$PATH:$HOME/.config/scripts"
export XDG_CONFIG_HOME=~/.config

# START - Managed by chef cookbook stripe_cpe_bin
alias tc='/usr/local/stripe/bin/test_cookbook'
alias cz='/usr/local/stripe/bin/chef-zero'
alias cookit='tc && cz'
# STOP - Managed by chef cookbook stripe_cpe_bin
