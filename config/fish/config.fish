if status is-interactive
    # Commands to run in interactive sessions can go here
end

# ran at fish start, disables the default welcome message
function fish_greeting
end

# allows us to source a custom work script, checked in seperately
if test -e ~/.work.fish
    source ~/.work.fish
end

# https://starship.rs/
starship init fish | source
