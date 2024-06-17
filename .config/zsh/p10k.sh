# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
if ! test -d ~/.config/powerlevel10k; then
  echo "powerlevel10k not found, git cloning into ~/.config/powerlevel10k"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
fi
source ~/.p10k.zsh
source ~/.config/powerlevel10k/powerlevel10k.zsh-theme
