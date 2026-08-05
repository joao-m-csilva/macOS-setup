#!/usr/bin/env bash

main () {
    echo ""
    echo "Installing Homebrew..."

    if ! command -v brew &> /dev/null
    then
        echo "Homebrew not found. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    else
        echo "Homebrew already installed."
    fi

    eval "$(/opt/homebrew/bin/brew shellenv)" 
    install_brew_packages

}

install_brew_packages () {
    echo ""
    echo "Installing programs..."

    brew bundle --file="$ROOT/Brewfile"
}
main
