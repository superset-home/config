# ==============================================================================
# FUZZY DIRECTORY NAVIGATION
# ==============================================================================

# Fuzzy find directories in $HOME and cd into selected one
cdf() {
    local dir
    dir=$(find ${1:-.} -path '*/\.*' -prune \
        -o -type d -print 2> /dev/null | fzf +m) &&
    cd "$dir"
}
