#!/usr/bin/env bash

EMAIL="${1:-}"
SSH_KEY="$HOME/.ssh/id_ed25519"

main(){
    while true
    do
       if [[ -f "$SSH_KEY" ]]; then
            echo "SSH Key already exists at $SSH_KEY"
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

ssh_key_generate() {

    ssh-keygen -t ed25519 -C "$USER_EMAIL" -f "$SSH_KEY"

    eval "$(ssh-agent -s)"

    ssh-add --apple-use-keychain ~/.ssh/id_ed25519

    pbcopy < ~/.ssh/id_ed25519.pub
    
    echo "The new SSH key was generated and copied to clipboard."
    echo "Paste it into GitHub."
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi