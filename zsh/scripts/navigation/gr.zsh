# ==============================================================================
# GIT ROOT NAVIGATION
# ==============================================================================

# CD to git repository root
alias gr='if [ "`git rev-parse --show-cdup`" != "" ]; then cd `git rev-parse --show-cdup`; fi'
