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

    # Re-bind Enter/Ctrl-C for oh-my-posh transient prompt (vi mode overwrites these)
    if functions -q _omp_enter_key_handler
        bind \r _omp_enter_key_handler -M default
        bind \r _omp_enter_key_handler -M insert
        bind \r _omp_enter_key_handler -M visual
        bind \n _omp_enter_key_handler -M default
        bind \n _omp_enter_key_handler -M insert
        bind \n _omp_enter_key_handler -M visual
    end
    if functions -q _omp_ctrl_c_key_handler
        bind \cc _omp_ctrl_c_key_handler -M default
        bind \cc _omp_ctrl_c_key_handler -M insert
        bind \cc _omp_ctrl_c_key_handler -M visual
    end
end