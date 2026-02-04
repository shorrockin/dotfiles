# User paths
fish_add_path ~/.config/scripts
fish_add_path ~/.local/bin

# System binaries (git-wrapper location)
fish_add_path /usr/local/bin

# Homebrew (macOS)
if test -d /opt/homebrew/bin
    fish_add_path /opt/homebrew/bin
    fish_add_path /opt/homebrew/sbin
end

# Go - Stripe managed SDK
if test -d ~/.cache/gocode/sdk/managed/bin
    fish_add_path ~/.cache/gocode/sdk/managed/bin
end

# Go user binaries
if test -d ~/go/bin
    fish_add_path ~/go/bin
end

# Ghostty CLI (macOS)
if test -d /Applications/Ghostty.app/Contents/MacOS
    fish_add_path /Applications/Ghostty.app/Contents/MacOS
end
