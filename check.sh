#!/bin/bash

# simple script to check to make sure that we have everything
# we want installed, generally useful on a new setup to checklist
# things a bit
function command_exists() {
    local name=$1
    command -v "$name" >/dev/null 2>&1
}

if command_exists nvim; then
    echo "nvim installed, expecting version v0.10.0 or later: $(nvim --version | head -n 1)"
else
    echo "❌ nvim is not installed"
fi 

if command_exists eza; then
    echo "eza installed, expecting version 0.18.0 or later: $(eza --version | awk 'NR==2')"
else
    echo "❌ eza is not installed"
fi

if command_exists fzf; then
    echo "fzf installed, expecting version 0.44.0 or later: $(fzf --version | head -n 1)"
else
    echo "❌ fzf is not installed"
fi

if command_exists bat; then 
    echo "bat installed, expecting version 0.18.0 or later: $(bat --version | head -n 1)"
elif command_exists batcat; then
    echo "bat installed, expecting version 0.18.0 or later: $(batcat --version | head -n 1)"
else
    echo "❌ bat is not installed"
fi

if command_exists zoxide; then
    echo "zoxide installed, expecting version 0.9.4 or later: $(zoxide --version | head -n 1)"
else
    echo "❌ zoxide is not installed"
fi

if command_exists tmux; then
    echo "tmux installed, expecting version 3.3a or later: $(tmux -V | head -n 1)"
else
    echo "❌ tmux is not installed"
fi

    
