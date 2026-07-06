# ==================================================
# ================= Navegação =======================
# ==================================================

# Lista arquivos em formato longo, incluindo ocultos,
# com tamanhos em formato legível (KB, MB, GB)
alias ll="ls -lah"


# ==================================================
# ==================== Git ==========================
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

# Git Fetch
alias gf="git fetch"

# Git Log (histórico em formato gráfico)
alias gl="git log --oneline --graph --decorate --all"


# ==================================================
# ================== Funções ========================
# ==================================================

# Inicializa um novo repositório Git
# Cria um README.md e um .gitignore padrão, caso não existam
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

    echo "✅ Repositório Git inicializado."
}