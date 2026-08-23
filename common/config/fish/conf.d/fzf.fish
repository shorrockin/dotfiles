# Check if fzf is installed and if the version is at least 0.48
function __fzf_check_version
    set -l fzf_version (fzf --version | string match -r '[0-9]+\.[0-9]+')
    set -l required_version "0.48"
    
    # Simple version comparison
    if test (printf "%s\n%s" $required_version $fzf_version | sort -V | head -n1) = $required_version
        return 0 # Version is equal or higher
    else
        return 1 # Version is lower
    end
end

if command -v fzf >/dev/null 2>&1
    if __fzf_check_version
        # Load fzf key bindings for fish - but don't call the function yet
        # It will be called from fish_user_key_bindings instead
        if test -e (dirname (status --current-filename))/fzf_key_bindings.fish
            source (dirname (status --current-filename))/fzf_key_bindings.fish
            # Don't call fzf_key_bindings here - it will be called in fish_user_key_bindings
        else
            # Check if fzf.fish is installed via Fisher or other methods
            if functions -q fzf_configure_bindings
                # Use the newer API if available
                fzf_configure_bindings --directory=\e\cc --git_log=\e\cg --git_status=\e\cs --history=\cr --variables=\cv --processes=\e\cp
            else
                # Fallback method: generate key bindings with fzf --fish
                set -l fzf_fish_bindings (fzf --fish)
                if test -n "$fzf_fish_bindings"
                    echo $fzf_fish_bindings | source
                else
                    echo "fzf fish bindings not available. Try installing the fzf.fish plugin."
                end
            end
        end
    else
        echo "fzf version is less than 0.48, skipping fzf keybinding setup"
    end
end

# Ensure these bindings work in vi mode
function fish_user_key_bindings
    # This will add fzf bindings while maintaining vi mode
    if functions -q fzf_key_bindings
        fzf_key_bindings
    end

    # Ensure Ctrl+R works in both vi modes
    bind -M insert \cr fzf-history-widget
    bind -M default \cr fzf-history-widget
end