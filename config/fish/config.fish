if status is-interactive
    # Commands to run in interactive sessions can go here
    # Set the SHELL environment variable to fish path
    set -gx SHELL (which fish)

    # Ensure true color support is advertised (Ghostty sets this locally,
    # but it gets lost in remote/nested tmux sessions)
    set -gx COLORTERM truecolor
end


# ran at fish start, disables the default welcome message
function fish_greeting
end

# source work stuff first (before oh-my-posh, since it overrides fish_mode_prompt)
if test -e ~/.work.fish
    source ~/.work.fish
end

# initialize oh-my-posh (after work stuff so our fish_mode_prompt takes precedence)
if command -v oh-my-posh > /dev/null
    oh-my-posh init fish --config ~/.config/oh-my-posh/config.json | source
end

# override fish_mode_prompt for oh-my-posh vi mode support (must be after work scripts)
function fish_mode_prompt
    set -gx OMP_FISH_BIND_MODE $fish_bind_mode
    set -g _omp_new_prompt 1
end

# npm global packages (claude-code, etc.)
fish_add_path ~/.npm-global/bin
