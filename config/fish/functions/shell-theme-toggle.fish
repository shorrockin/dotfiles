function shell-theme-toggle
    set -l ghostty_config ~/.config/ghostty/config
    set -l alacritty_config ~/.config/alacritty/alacritty.toml
    set -l omp_dark ~/.config/oh-my-posh/config.json
    set -l omp_light ~/.config/oh-my-posh/config-light.json

    # Detect current theme from Ghostty config (source of truth for persisted state)
    if test -f $ghostty_config; and rg -q '^theme = catppuccin-mocha' $ghostty_config
        set target_mode light
    else if set -q SHELL_THEME; and test "$SHELL_THEME" = light
        set target_mode dark
    else
        set target_mode light
    end

    if test $target_mode = light
        # --- Ghostty ---
        if test -f $ghostty_config
            sed -i '' \
                -e 's/^theme = catppuccin-mocha\.conf/# theme = catppuccin-mocha.conf/' \
                -e 's/^# theme = "Catppuccin Latte"/theme = "Catppuccin Latte"/' \
                $ghostty_config
            if test "$TERM_PROGRAM" = ghostty; and command -q ghostty
                ghostty +reload-config 2>/dev/null
            end
        end

        # --- Alacritty ---
        if test -f $alacritty_config
            sed -i '' \
                -e 's|^    "~/.config/alacritty/catppuccin-mocha.toml"|    # "~/.config/alacritty/catppuccin-mocha.toml"|' \
                -e 's|^    # "~/.config/alacritty/catppuccin-latte.toml"|    "~/.config/alacritty/catppuccin-latte.toml"|' \
                $alacritty_config
        end

        # --- Any terminal: Catppuccin Latte via OSC escape sequences ---
        _osc_apply_theme \
            "#EFF1F5" "#4C4F69" \
            "#5C5F77" "#D20F39" "#40A02B" "#DF8E1D" "#1E66F5" "#EA76CB" "#04A5E5" "#ACB0BE" \
            "#6C6F85" "#D20F39" "#40A02B" "#DF8E1D" "#1E66F5" "#EA76CB" "#04A5E5" "#BCC0CC"

        set -gx OMP_CONFIG $omp_light
        set -gx SHELL_THEME light
        echo "Switched to light mode (Catppuccin Latte)"
    else
        # --- Ghostty ---
        if test -f $ghostty_config
            sed -i '' \
                -e 's/^# theme = catppuccin-mocha\.conf/theme = catppuccin-mocha.conf/' \
                -e 's/^theme = "Catppuccin Latte"/# theme = "Catppuccin Latte"/' \
                $ghostty_config
            if test "$TERM_PROGRAM" = ghostty; and command -q ghostty
                ghostty +reload-config 2>/dev/null
            end
        end

        # --- Alacritty ---
        if test -f $alacritty_config
            sed -i '' \
                -e 's|^    "~/.config/alacritty/catppuccin-latte.toml"|    # "~/.config/alacritty/catppuccin-latte.toml"|' \
                -e 's|^    # "~/.config/alacritty/catppuccin-mocha.toml"|    "~/.config/alacritty/catppuccin-mocha.toml"|' \
                $alacritty_config
        end

        # --- Any terminal: Catppuccin Mocha via OSC escape sequences ---
        _osc_apply_theme \
            "#1E1E2E" "#CDD6F4" \
            "#45475A" "#F38BA8" "#A6E3A1" "#F9E2AF" "#89B4FA" "#F5C2E7" "#94E2D5" "#BAC2DE" \
            "#585B70" "#F38BA8" "#A6E3A1" "#F9E2AF" "#89B4FA" "#F5C2E7" "#94E2D5" "#A6ADC8"

        set -gx OMP_CONFIG $omp_dark
        set -gx SHELL_THEME dark
        echo "Switched to dark mode (Catppuccin Mocha)"
    end

    # Re-initialize oh-my-posh in this shell
    oh-my-posh init fish --config $OMP_CONFIG | source
end

# Emits OSC escape sequences to repaint terminal colors in the current session.
# Args: bg fg black red green yellow blue magenta cyan white (x2 for bright variants)
function _osc_apply_theme
    set -l bg $argv[1]
    set -l fg $argv[2]
    # OSC 11 = background, OSC 10 = foreground
    printf "\033]11;%s\007" $bg
    printf "\033]10;%s\007" $fg
    # OSC 4 = palette slot N
    for i in (seq 0 15)
        printf "\033]4;%d;%s\007" $i $argv[(math $i + 3)]
    end
end
