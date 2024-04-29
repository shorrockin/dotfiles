# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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

# load everything in this directory, we git stow a bunch of different .sh files here 
# for both work and personal projects (separate git repos)
for file in ~/.config/zsh/*.sh
do
    source "$file"
done

# https://github.com/ajeetdsouza/zoxide, need to cleanup how this is aliased
if command -v z > /dev/null 2>&1; then
    eval "$(zoxide init zsh)"
    alias cd=z
fi

# This loads nvm if it exists and/is necessary
[ -s $HOME/.nvm/nvm.sh ] && . $HOME/.nvm/nvm.sh 

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# set's up fzf
[ -f ~/.fzf.zsh ] || source ~/.fzf.zsh

# directory containing custom scripts across our different git stow'd repos
export PATH="$PATH:$HOME/.config/scripts"
