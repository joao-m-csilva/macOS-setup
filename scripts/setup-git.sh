#!/usr/bin/env bash

ROOT="${ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"

main () {
    if ! command -v git &> /dev/null
    then
        echo "Git not found. Installing..."
        install_git
        git_config_setup
        git_ignore_global_config
    else
        echo "Git already installed."
        git_config_setup
        git_ignore_global_config
        echo "Finished!"
        echo "Git version "
        git --version
    fi
}

install_git () {
    brew install git
}

git_config_setup () {
    echo ""
    echo "Setting up Git config..."

    TARGET_CONFIG="$HOME/.gitconfig"
    SOURCE_CONFIG="$ROOT/templates/git/.gitconfig"

    if [[ ! -f "$TARGET_CONFIG" && -f "$SOURCE_CONFIG" ]]; then
        cp "$SOURCE_CONFIG" "$TARGET_CONFIG"

        echo "Type your Git user name:"
        read -r GIT_NAME
        while [[ -z "$GIT_NAME" ]]; do
            echo "Name cannot be empty. Type your Git user name:"
            read -r GIT_NAME
        done

        echo "Type your Git user email:"
        read -r GIT_EMAIL
        while [[ -z "$GIT_EMAIL" ]]; do
            echo "Email cannot be empty. Type your Git user email:"
            read -r GIT_EMAIL
        done

        git config --global user.name "$GIT_NAME"
        git config --global user.email "$GIT_EMAIL"

        echo "Git config created at $TARGET_CONFIG"
    elif [[ -f "$TARGET_CONFIG" ]]; then
        echo "Git config already exists at $TARGET_CONFIG. Kept unchanged."

        CURRENT_NAME=$(git config --global user.name 2>/dev/null || true)
        CURRENT_EMAIL=$(git config --global user.email 2>/dev/null || true)

        if [[ -z "$CURRENT_NAME" ]]; then
            echo "Type your Git user name:"
            read -r GIT_NAME
            if [[ -n "$GIT_NAME" ]]; then
                git config --global user.name "$GIT_NAME"
            fi
        fi

        if [[ -z "$CURRENT_EMAIL" ]]; then
            echo "Type your Git user email:"
            read -r GIT_EMAIL
            if [[ -n "$GIT_EMAIL" ]]; then
                git config --global user.email "$GIT_EMAIL"
            fi
        fi
    fi
}

git_ignore_global_config () {
    echo ""
    echo "Setting up Git ignore global..."

    cp "$ROOT/templates/git/.gitignore_global" "$HOME/.gitignore_global"

    git config --global core.excludesfile "$HOME/.gitignore_global"
}

main
