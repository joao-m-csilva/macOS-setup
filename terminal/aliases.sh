# ==================================================
# ================= Navigation ======================
# ==================================================

# Lists files in long format, including hidden ones,
# with sizes in human-readable format (KB, MB, GB)
alias ll="ls -lah"

# Quick parent directory navigation
alias ..="cd .."
alias ...="cd ../.."

# Clear terminal screen
alias c="clear"

# Reload Zsh configuration
alias reload="source ~/.zshrc"


# ==================================================
# ==================== Git =========================
# ==================================================

# Git Status
alias gs="git status"

# Git Add
alias ga="git add"

# Git Add All
alias gaa="git add ."

# Git Commit
alias gc="git commit"

# Git Commit Amend
alias gca="git commit --amend"

# Git Push
alias gp="git push"

# Git Pull
alias gpl="git pull"

# Git Fetch
alias gf="git fetch"

# Git Diff
alias gd="git diff"

# Git Log (history in graphical format)
alias gl="git log --oneline --graph --decorate --all"


# ==================================================
# ================== Functions =====================
# ==================================================

# Initializes a new Git repository
# Creates a README.md and a default .gitignore if they do not exist
ginit() {
    git init

    if [[ ! -f README.md ]]; then
        echo "# $(basename "$PWD")" > README.md
    fi

    if [[ ! -f .gitignore ]]; then
        cat > .gitignore <<EOF
node_modules/
.env
dist/
.DS_Store
EOF
    fi

    echo "Git repository initialized."
}


# ==================================================
# ==================== Bash ========================
# ==================================================

# Use Homebrew's Bash instead of the old native version
alias bash='/opt/homebrew/bin/bash'

