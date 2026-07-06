#!/bin/zsh

EMAIL="$1"

if [ -z "$EMAIL" ]; then
    echo "Uso: ./setup-ssh.sh seu-email@example.com"
    exit 1
fi

ssh-keygen -t ed25519 -C "$EMAIL"

eval "$(ssh-agent -s)"

ssh-add --apple-use-keychain ~/.ssh/id_ed25519

pbcopy < ~/.ssh/id_ed25519.pub

echo
echo "A chave pública foi copiada para a área de transferência."
echo "Cole-a no GitHub."