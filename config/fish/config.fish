if status is-interactive
    # Commands to run in interactive sessions can go here
    # Set the SHELL environment variable to fish path
    set -gx SHELL (which fish)
end


# ran at fish start, disables the default welcome message
function fish_greeting
end

# disable vi mode indicator (we use oh-my-posh instead)
function fish_mode_prompt
    set -gx OMP_FISH_BIND_MODE $fish_bind_mode
    set -g _omp_new_prompt 1
end

if command -v oh-my-posh > /dev/null
    oh-my-posh init fish --config ~/.config/oh-my-posh/config.json | source
end

if test -e ~/.work.fish
    source ~/.work.fish
end

# opencode
fish_add_path /home/chris/.opencode/bin
