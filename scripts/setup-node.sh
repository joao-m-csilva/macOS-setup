#!/usr/bin/env bash

main () {

    export NVM_DIR="$HOME/.nvm"

    NVM_SH="/opt/homebrew/opt/nvm/nvm.sh"

     if [ -s "$NVM_SH" ]; then
        . "$NVM_SH"
        install_node
    else
        echo "nvm not found at $NVM_SH"
        echo "Installing..."
        install_nvm

        if [ -s "$NVM_SH" ]; then
            . "$NVM_SH"

            install_node
        fi
    fi
}

install_node () {
    nvm install --lts
    nvm use --lts
    npm install -g npm
}

install_nvm () {
    brew install nvm
}
main


