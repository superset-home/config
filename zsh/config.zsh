# ==============================================================================
# OH-MY-ZSH CONFIGURATION
# ==============================================================================

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="satya"

plugins=(
  vi-mode
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
  extract
)

source $ZSH/oh-my-zsh.sh

# ==============================================================================
# GENERAL SHELL OPTIONS
# ==============================================================================

# Reduce vi-mode key timeout for faster mode switching
export KEYTIMEOUT=20

# ==============================================================================
# ALIASES - CONFIG MANAGEMENT
# ==============================================================================

alias sz="source ~/.zshrc"
alias st="tmux source-file ~/.tmux.conf"
alias z="vim ~/.zshrc"

# ==============================================================================
# ALIASES - TOOL PREFERENCES
# ==============================================================================

# FZF with custom color scheme
alias fzf="fzf --color fg:242,bg:233,hl:65,fg+:15,bg+:234,hl+:108 --color info:108,prompt:109,spinner:108,pointer:168,marker:168"

# Use neovim instead of vim
alias vim="nvim"

# Resume Claude Code session with permission checks skipped
alias cc="claude --dangerously-skip-permissions -c"

# Ag with sensible ignore directories
alias ag="ag --ignore-dir playground --ignore-dir virtualenv_run --ignore-dir virtualenv_run_py27 --ignore-dir log --ignore-dir node_modules --ignore-dir coverage --ignore-dir logs --ignore-dir venv  --ignore-dir virtualenv_py3  --ignore-dir docker-venv-py3"

# ==============================================================================
# KEYBINDINGS
# ==============================================================================

# Accept autosuggestion with Ctrl+Space
bindkey '^ ' autosuggest-accept

# Forward word with Ctrl+T
bindkey '^T' forward-word

# Vi command mode with jk
bindkey jk vi-cmd-mode

# Fix issues with vi-mode plugin and reverse searching
# Up arrow - fuzzy find history forward
if [[ "${terminfo[kcuu1]}" != "" ]]; then
  autoload -U up-line-or-beginning-search
  zle -N up-line-or-beginning-search
  bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
fi

# Down arrow - fuzzy find history backward
if [[ "${terminfo[kcud1]}" != "" ]]; then
  autoload -U down-line-or-beginning-search
  zle -N down-line-or-beginning-search
  bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
fi

# ==============================================================================
# FZF CONFIGURATION
# ==============================================================================

export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'

# ==============================================================================
# SOURCE CUSTOM SCRIPTS
# ==============================================================================

# Get the directory where this .zshrc is located
ZSHRC_DIR="$(dirname ${(%):-%x})"

# Source all index.zsh files from script modules
for script in "$ZSHRC_DIR"/scripts/*/index.zsh; do
  [ -f "$script" ] && source "$script"
done

