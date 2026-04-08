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
# invalidate the cached init script only when the binary path changes
if command -v oh-my-posh > /dev/null
    set -l omp_config ~/.config/oh-my-posh/config.json
    if set -q OMP_CONFIG
        set omp_config $OMP_CONFIG
    end

    set -l omp_cache_dir ~/.cache/oh-my-posh
    set -l omp_cache_marker $omp_cache_dir/init.binary-path
    set -l omp_binary (command -s oh-my-posh)
    command mkdir -p $omp_cache_dir

    set -l cached_binary
    if test -r $omp_cache_marker
        set cached_binary (string trim -- (command cat $omp_cache_marker))
    end

    if test "$cached_binary" != "$omp_binary"
        command find $omp_cache_dir -name 'init.*.fish' -delete 2>/dev/null
        command printf '%s\n' "$omp_binary" > $omp_cache_marker
    end

    oh-my-posh init fish --config $omp_config | source
end

# override fish_mode_prompt for oh-my-posh vi mode support (must be after work scripts)
function fish_mode_prompt
    set -gx OMP_FISH_BIND_MODE $fish_bind_mode
    set -g _omp_new_prompt 1
end

# npm global packages (claude-code, etc.)
fish_add_path ~/.npm-global/bin

# abbreviations
abbr -a claude-danger 'claude --dangerously-skip-permissions'
abbr -a fish-source 'source ~/.config/fish/config.fish'
