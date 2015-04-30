#!/bin/bash

source "$(dirname $0)/functions.sh"

stash="ask"
rebaseFrom="origin/develop"
for param in $*; do
    # -stash=[ask/yes/no]
    if [ ${param:0:7} == '-stash=' ]; then
        stash="${param:7}"

    # remote/branch
    else
        rebaseFrom=$param
    fi
done

title "Rebase from $rebaseFrom"

gitBranch="$(getGitBranch)"
if [ "$gitBranch" == "" ]; then
    cancelScript "Directory does not appear to be a git repository."
fi

editedFiles="$(git status --porcelain)"
countEditedFiles="${#editedFiles[@]}"

if [ "$stash" == "ask" ] && [ "$countEditedFiles" -gt "0" ]; then
    ask "Repository contains unstaged changes. Do you want to stash them ? (Y/n)"
    read readStash
    echo ''
    if [ "$readStash" == "" ] || [ "$readStash" == "y" ] || [ "$readStash" == "Y" ]; then
        stash="yes"
    fi
fi
if [ "$countEditedFiles" -gt "0" ] && [ "$stash" == "yes" ]; then
    execCmd "git stash"
    echo ""
fi

execCmd "git fetch"
echo ""
execCmd "git rebase -p $rebaseFrom"

if [ "$countEditedFiles" -gt "0" ] && [ "$stash" == "yes" ]; then
    echo ""
    execCmd "git stash pop"
fi

echoOk
exit 0
