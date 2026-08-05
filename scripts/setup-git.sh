#!/usr/bin/env bash

main () {
    if ! command -v git &> /dev/null
    then
        echo "Git not found. Installing..."
        install_git
        git_ignore_global_config
    else
        echo "Git already installed."
        echo "Setting up Git ignore global."
        git_ignore_global_config
        echo "Finished!"
        echo "Git version "
        git --version
    fi
}

install_git () {
    brew install git
}

git_ignore_global_config () {
    echo ""
    echo "Setting up Git ignore global..."

    cp "$ROOT/templates/git/.gitignore_global" ~/.gitignore_global

    git config --global core.excludesfile ~/.gitignore_global
}
main
