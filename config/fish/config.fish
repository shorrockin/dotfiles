if status is-interactive
    # Commands to run in interactive sessions can go here
    # Set the SHELL environment variable to fish path
    set -gx SHELL (which fish)
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

# opencode
fish_add_path /home/chris/.opencode/bin
