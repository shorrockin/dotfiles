echo "Setting up system so stow works"

echo " - Creating the ~/.config directory for nvim, scripts, etc"
mkdir -p ~/.config

echo " - Creating ~/.config/scripts directory so we can link directory to the script, not the directory"
mkdir -p ~/.config/scripts

echo " - Creating ~/.config/zsh directory which we will auto-load as part of zshrc"
mkdir -p ~/.config/zsh
