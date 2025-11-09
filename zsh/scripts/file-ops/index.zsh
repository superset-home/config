# ==============================================================================
# FILE OPERATIONS
# ==============================================================================

# Open file with fuzzy finder and vim
vf() {
    result=$(fzf)
    if [ ! -z "$result" ]; then
        vim $result
    fi
}

# Find files by name pattern
f() {
    find . -name "*$1*"
}

# Search and replace in files
# Usage: sr "search_pattern" "replacement"
sr() {
    grep -rl "$1" ./ | xargs sed -i "s/$1/$2/g"
}
