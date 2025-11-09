# ==============================================================================
# DEVELOPMENT UTILITIES
# ==============================================================================

# Run pytest on a file found via fuzzy finder
ptf() {
    result=$(find . -name "*test*.py" | fzf)
    if [ ! -z "$result" ]; then
        pytest $result
    fi
}

# Run python file found via fuzzy finder
pyf() {
    result=$(find . -name "*.py" | fzf)
    if [ ! -z "$result" ]; then
        python $result
    fi
}

# Unix timestamp conversion utility
# Usage: dt          # Get current timestamp
#        dt <timestamp>  # Convert timestamp to date
dt() {
    if [ -z $1 ]; then
        date '+%s'
    else
        date -d "@$1"
    fi
}
