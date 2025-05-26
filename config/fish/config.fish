if status is-interactive
    # Commands to run in interactive sessions can go here
end

# ran at fish start, disables the default welcome message
function fish_greeting
end

# https://starship.rs/
starship init fish | source
