#!/usr/bin/env bash

EMAIL="${1:-}"
SSH_KEY="$HOME/.ssh/id_ed25519"
SSH_CONFIG="$HOME/.ssh/config"

main(){
    while true
    do
       if [[ -f "$SSH_KEY" ]]; then
            echo "SSH Key already exists at $SSH_KEY"
            configure_ssh_config
            pbcopy < "$SSH_KEY.pub"
            echo "SSH Key copied to the clipboard."
            break
        elif [[ -n "$EMAIL" ]]
        then
            USER_EMAIL="$EMAIL"
            ssh_key_generate
            break
        elif [[ -n "$USER_EMAIL" ]]
        then
            ssh_key_generate 
            break
        else
            echo "Type the e-mail to link to the SSH Key"
            read -r EMAIL
        fi
    done 
    return 0
}

configure_ssh_config() {
    local ssh_dir
    ssh_dir="$(dirname "$SSH_CONFIG")"
    mkdir -p "$ssh_dir"
    chmod 700 "$ssh_dir"

    if [[ ! -f "$SSH_CONFIG" ]] || ! grep -Fq "IdentityFile $SSH_KEY" "$SSH_CONFIG"; then
        cat >> "$SSH_CONFIG" <<EOF

Host *
    AddKeysToAgent yes
    UseKeychain yes
    IdentityFile $SSH_KEY
EOF
        chmod 600 "$SSH_CONFIG"
    fi
}

ssh_key_generate() {
    mkdir -p "$(dirname "$SSH_KEY")"
    chmod 700 "$(dirname "$SSH_KEY")"

    ssh-keygen -t ed25519 -C "$USER_EMAIL" -f "$SSH_KEY"

    configure_ssh_config

    eval "$(ssh-agent -s)"

    ssh-add --apple-use-keychain "$SSH_KEY"

    pbcopy < "${SSH_KEY}.pub"
    
    echo "The new SSH key was generated and copied to clipboard."
    echo "Paste it into GitHub."
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
