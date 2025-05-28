if status is-interactive
    # Commands to run in interactive sessions can go here
end


# ran at fish start, disables the default welcome message
function fish_greeting
end

if command -v starship > /dev/null
    starship init fish | source
end

if test -e ~/.work.fish
    source ~/.work.fish
end
