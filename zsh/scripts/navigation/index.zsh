# ==============================================================================
# NAVIGATION SCRIPTS
# ==============================================================================

# Get the directory where this index.zsh is located
SCRIPT_DIR="$(dirname ${(%):-%x})"

# Source all navigation scripts
source "$SCRIPT_DIR/gt.zsh"
source "$SCRIPT_DIR/cdf.zsh"
source "$SCRIPT_DIR/gr.zsh"
