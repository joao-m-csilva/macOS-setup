#!/usr/bin/env bash

EMAIL="$1"

if [ -z "$EMAIL" ]; then
    echo "Use: ./setup-ssh.sh seu-email@example.com"
    exit 1
fi

SSH_KEY="$HOME/.ssh/id_ed25519"

if [[ -f "$SSH_KEY" ]]; then
    echo "SSH Key already exists at $SSH_KEY"
    pbcopy < "$SSH_KEY.pub"
    echo "SSH Key copied to the clipboard."
    exit 0
fi

ssh-keygen -t ed25519 -C "$EMAIL" -f "$SSH_KEY"

eval "$(ssh-agent -s)"

ssh-add --apple-use-keychain ~/.ssh/id_ed25519

pbcopy < ~/.ssh/id_ed25519.pub

echo
echo "The new SSH key was generated and copied to clipboard."
echo "Paste it into GitHub."