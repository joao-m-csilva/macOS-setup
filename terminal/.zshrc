# ==========================
# NVM
# ==========================

export NVM_DIR="$HOME/.nvm"

[[ -s "$(brew --prefix nvm)/nvm.sh" ]] && source "$(brew --prefix nvm)/nvm.sh"


# ==========================
# SDKMAN!
# ==========================

export SDKMAN_DIR="$HOME/.sdkman"

[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"


# ==========================
# Personal config
# ==========================

source "$HOME/.config/terminal/exports.sh"
source "$HOME/.config/terminal/aliases.sh"