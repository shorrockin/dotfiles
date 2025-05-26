# GIT 
abbr --add gco git checkout
abbr --add gs git status
abbr --add gd git diff
abbr --add g git
abbr --add gpsh git push
abbr --add gpshf git push --force
abbr --add gpr git pull --rebase origin HEAD
abbr --add gl "git log --graph --pretty=format:'%an: %s - %Cred%h%Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
abbr --add gc "git add --all . && git add -u . && git commit -am"
abbr --add gcnv "git add --all . && git add -u . && git commit --no-verify -am"
abbr --add gp git pull
abbr --add gb "git reflog show --pretty=format:'%gs ~ %gd' --date=relative | grep 'checkout:' | grep -oE '[^ ]+ ~ .*' | awk -F~ '!seen[\$1]++' | head -n 10 | awk -F' ~ HEAD@{' '{printf(\"  \\033[33m%s: \\033[37m %s\\033[0m\\n\", substr(\$2, 1, length(\$2)-1), \$1)}'"
abbr --add gundo "git reset --soft HEAD && git restore --staged ."
abbr --add gamend "git commit --amend"
abbr --add info neofetch
# EZA
abbr --add l eza
abbr --add ll eza --all --long --icons --git --no-permissions
abbr --add lt eza --tree --level 3 --long --icons --git --no-permissions

# EZA
abbr --add l eza
abbr --add ll eza --all --long --icons --git --no-permissions
abbr --add lt eza --tree --level 3 --long --icons --git --no-permissions

# OTHER 
abbr --add vim nvim
abbr --add vi nvim
abbr --add v nvim
abbr --add ts tmux-sessionizer
abbr --add matrix cmatrix -s -r
abbr --add stow dots stow
abbr --add lg lazygit 

# REPLACEMENTS REPLACEMENTS
abbr --add cat bat
abbr --add more most
