#!/usr/bin/env bash

EMAIL="$1"

if [ -z "$EMAIL" ]; then
    echo "Uso: ./setup-ssh.sh seu-email@example.com"
    exit 1
fi

SSH_KEY="$HOME/.ssh/id_ed25519"

if [[ -f "$SSH_KEY" ]]; then
    echo "Chave SSH já existe em $SSH_KEY"
    pbcopy < "$SSH_KEY.pub"
    echo "Chave pública existente copiada."
    exit 0
fi

ssh-keygen -t ed25519 -C "$EMAIL" -f "$SSH_KEY"

eval "$(ssh-agent -s)"

ssh-add --apple-use-keychain ~/.ssh/id_ed25519

pbcopy < ~/.ssh/id_ed25519.pub

echo
echo "A nova chave pública foi gerada e copiada para a área de transferência."
echo "Cole-a no GitHub."