#!/usr/bin/env bash

export NVM_DIR="$HOME/.nvm"

NVM_SH="/opt/homebrew/opt/nvm/nvm.sh"

if [ -s "$NVM_SH" ]; then
    . "$NVM_SH"
else
    echo "nvm não encontrado em $NVM_SH"
    exit 1
fi

nvm install --lts
nvm use --lts

npm install -g npm