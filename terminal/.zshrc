# ==========================
# Shell
# ==========================

export EDITOR="vim"

# ==========================
# Homebrew
# ==========================

eval "$(/opt/homebrew/bin/brew shellenv)"

# ==========================
# NVM
# ==========================

export NVM_DIR="$HOME/.nvm"

[[ -s "$(brew --prefix nvm)/nvm.sh" ]] && source "$(brew --prefix nvm)/nvm.sh"

# ==========================
# Configurações pessoais
# ==========================

source ~/.config/terminal/exports.sh
source ~/.config/terminal/aliases.sh