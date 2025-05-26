function git-branch
    git checkout -b $1
    git push --set-upstream origin $1
end

function git-fix 
  set AUTOSQUASH_AT=$(git log --format=format:%H $1^1 -1)
  git add --all . && git add -u . && git commit -a --no-verify --fixup $1 
  git rebase -i --autosquash $AUTOSQUASH_AT
end

# from the fish docs, .. goes back one, ... goes back two, etc
function multicd
    echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
end
abbr --add dotdot --regex '^\.\.+$' --function multicd

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
