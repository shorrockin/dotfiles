version_gte() {
  [ "$(echo -e "$1\n$2" | sort -Vr | head -n1)" = "$1" ]
}

# Check if fzf is installed and if the version is 0.44 or later
if command -v fzf &> /dev/null; then
  FZF_VERSION=$(fzf --version | head -n 1)
  REQUIRED_VERSION="0.48"

  if version_gte "$FZF_VERSION" "$REQUIRED_VERSION"; then
    # set's up fzf with default keybinds
    # 1. ctrl-t - paste the selected file path into the command line
    # 2. ctrl-r - paste the selected command into the command line
    # 3. alt-c - cd into the selected directory
    source <(fzf --zsh)
  else
    echo "fzf version is less than 0.48, skipping fzf keybinding setup"
  fi
else
  echo "fzf is not installed, skipping fzf keybinding setup"
fi

