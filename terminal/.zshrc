# ==========================
# Oh My Zsh
# ==========================

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""

plugins=(
  git
  web-search
  zsh-autosuggestions
  zsh-syntax-highlighting
)

[[ -s "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"


# ==========================
# Tool PATHs
# ==========================

export PATH="$HOME/.local/bin:$PATH:$HOME/.dotnet/tools"


# ==========================
# NVM
# ==========================

export NVM_DIR="$HOME/.nvm"

if [[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]]; then
    source "/opt/homebrew/opt/nvm/nvm.sh"
elif command -v brew &> /dev/null && [[ -s "$(brew --prefix nvm)/nvm.sh" ]]; then
    source "$(brew --prefix nvm)/nvm.sh"
fi


# ==========================
# Personal config
# ==========================

[[ -f "$HOME/.config/terminal/exports.sh" ]] && source "$HOME/.config/terminal/exports.sh"

[[ -f "$HOME/.config/terminal/aliases.sh" ]] && source "$HOME/.config/terminal/aliases.sh"


# ==========================
# Prompt & Shell Integrations
# ==========================

if command -v oh-my-posh &> /dev/null; then
    eval "$(oh-my-posh init zsh --config tokyonight_storm)"
fi

if command -v fzf &> /dev/null; then
    eval "$(fzf --zsh)"
fi

if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
fi


# ==========================
# SDKMAN! (keep at the end)
# ==========================

export SDKMAN_DIR="$HOME/.sdkman"

[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

