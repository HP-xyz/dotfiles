# Common shell library

GIT_deleteLocalMergedBranches()
{
    for mergedBranch in $(git for-each-ref --format '%(refname:short)' --merged HEAD refs/heads/)
    do
        git branch -d ${mergedBranch}
    done 
}
