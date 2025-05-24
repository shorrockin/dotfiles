if status is-interactive
    # Commands to run in interactive sessions can go here
end

# ENVIRONMENT VARIABLES
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx BROWSER nvim
set -gx PAGER most

# PATH
fish_add_path ~/.config/scripts

# GIT ABBREVIATIONS
abbr --add gco git checkout
abbr --add gs git status
abbr --add gd git diff
abbr --add g git
abbr --add gpsh git push
abbr --add gpshf git push -force
abbr --add gpr git pull --rebase origin HEAD
abbr --add glog "git log --graph --pretty=format:'%an: %s - %Cred%h%Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"

# OTHER ABBREVIATIONS
abbr --add vim nvim
abbr --add vi nvim
abbr --add ts tmux-sessionizer
abbr --add l eza
abbr --add ll eza -lha
abbr --add matrix cmatrix -s -r

# FUNCTIONS
function git-branch
    git checkout -b $1
    git push --set-upstream origin $1
end

function git-fix 
  set AUTOSQUASH_AT=$(git log --format=format:%H $1^1 -1)
  git add --all . && git add -u . && git commit -a --no-verify --fixup $1 
  git rebase -i --autosquash $AUTOSQUASH_AT
end

# function git-clean 
#     # Make sure we're working with the most up-to-date version of master.
#     git fetch
#
#     # garbage collect
#     git gc
#
#     # Prune obsolete remote tracking branches. These are branches that we
#     # once tracked, but have since been deleted on the remote.
#     git remote prune origin
#
#     # List all the branches that have been merged fully into master, and
#     # then delete them. We use the remote master here, just in case our
#     # local master is out of date.
#     git branch --merged origin/master | grep -v 'master$' | grep -v 'master-passing-tests$' | xargs git branch -d
#
#     # git-delete-squashed: https://github.com/not-an-aardvark/git-delete-squashed
#     git checkout -q master && git for-each-ref refs/heads/ "--format=%(refname:short)" | while read branch; do mergeBase=$(git merge-base master $branch) && [[ $(git cherry master $(git commit-tree $(git rev-parse $branch^{tree}) -p $mergeBase -m _)) == "-"* ]] && git branch -D $branch; done
#
#     # clean up loose ends
#     git prune
# end

function fish_greeting
end

# ALIASES

# PROMPT INIT
starship init fish | source
