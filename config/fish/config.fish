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

# Only run interactive-only setup (prompts, work tooling) when actually interactive.
# display-popup and other non-interactive fish invocations skip this entirely.
if status is-interactive
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

        # The init script hardcodes the absolute Nix store path in $_omp_executable,
        # which breaks in long-lived shells after nixos-rebuild garbage-collects the
        # old store path. Override with the stable profile symlink so existing shells
        # survive rebuilds. On non-Nix systems $omp_binary is already the real path,
        # so this is a no-op in effect.
        set --global _omp_executable $omp_binary
    end

    # Apply dark Mocha colors on startup in non-Ghostty terminals (Ghostty manages its own background).
    # Without this, the dark background only appears after toggling light→dark via shell-theme-toggle.
    if not set -q GHOSTTY_RESOURCES_DIR; and not set -q SHELL_THEME
        printf "\033]11;%s\007" "#1E1E2E"
        printf "\033]10;%s\007" "#CDD6F4"
        for i in (seq 0 15)
            set -l mocha_palette "#45475A" "#F38BA8" "#A6E3A1" "#F9E2AF" "#89B4FA" "#F5C2E7" "#94E2D5" "#BAC2DE" "#585B70" "#F38BA8" "#A6E3A1" "#F9E2AF" "#89B4FA" "#F5C2E7" "#94E2D5" "#A6ADC8"
            printf "\033]4;%d;%s\007" $i $mocha_palette[(math $i + 1)]
        end
        set -gx SHELL_THEME dark
    end

    # override fish_mode_prompt for oh-my-posh vi mode support (must be after work scripts)
    function fish_mode_prompt
        set -gx OMP_FISH_BIND_MODE $fish_bind_mode
        set -g _omp_new_prompt 1
    end
end

# npm global packages (claude-code, etc.)
fish_add_path ~/.npm-global/bin
