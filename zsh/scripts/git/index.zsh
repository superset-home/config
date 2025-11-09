# ==============================================================================
# GIT UTILITIES
# ==============================================================================

# Clone a repository using fuzzy search
clone() {
    repo=$(gh repo list --limit 1000 | fzf | awk '{print $1}')
    if [ ! -z "$repo" ]; then
        gh repo clone $repo
    fi
}

# Fuzzy checkout git branch
co() {
    local branches branch
    branches=$(git branch -a) &&
    branch=$(echo "$branches" | fzf +m) &&
    git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# Pull feature branch from origin
gpullfeat() {
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    echo "Pulling $CURRENT_BRANCH from origin"
    git pull origin $CURRENT_BRANCH
}

# Merge feature branch to master
gfeatmaster() {
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    echo "Merging $CURRENT_BRANCH into master"
    git checkout master
    git merge $CURRENT_BRANCH
}

# Rebase current branch on master
gbasemaster() {
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    echo "Rebasing $CURRENT_BRANCH on master"
    git rebase master
}

# Reset current branch to master
gresetmaster() {
    git checkout master
    git reset --hard origin/master
}

# CD to git repository root
cdr() {
    cd "$(git rev-parse --show-toplevel)"
}

# View files changed in last commit with fzf and open in vim
vd() {
    result=$(git diff --name-only HEAD~1 | fzf)
    if [ ! -z "$result" ]; then
        vim $result
    fi
}

# Show git diff for last N commits
gdiffhead() {
    git diff HEAD~$1
}

# Create new branch and set upstream tracking
gbranch() {
    git checkout -b $1
    git push -u origin $1
}
