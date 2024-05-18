echo "Setting up system so stow works"

echo " - Creating the ~/.config directory for nvim, scripts, etc"
mkdir -p ~/.config

echo " - Creating ~/.config/scripts directory so we can link directory to the script, not the directory"
mkdir -p ~/.config/scripts

echo " - Creating ~/.config/zsh directory which we will auto-load as part of zshrc"
mkdir -p ~/.config/zsh

echo " - Creating ~/.config/nvim/ directories for lua scripts, so that we don't link nvim wholesale, allowing private modules"
mkdir -p ~/.config/nvim/lua
mkdir -p ~/.config/nvim/lua/plugins
mkdir -p ~/.config/nvim/after/plugin
mkdir -p ~/.config/nvim/after/ftplugin
