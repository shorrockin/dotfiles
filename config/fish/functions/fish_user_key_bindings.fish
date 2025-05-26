function fish_user_key_bindings
    # First set up vi mode
    fish_vi_key_bindings
    
    # Then load fzf key bindings
    if functions -q fzf_key_bindings
        fzf_key_bindings
    end

    # Make sure Ctrl+R works in both vi modes with fzf
    bind -M insert \cr fzf-history-widget
    bind -M default \cr fzf-history-widget
end