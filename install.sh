#!/usr/bin/env bash

set -e

ROOT="$(cd "$(dirname "$0")" && pwd)"
export ROOT
BOTH_OPTION=0

main () {

   cat << "EOF"
=========================================================================
                             macOS Setup
=========================================================================

       _ __ ___   __ _  ___  ___  ____    ____       _
      | '_ ` _ \ / _` |/ __|/ _ \/ ___|  / ___|  ___| |_ _   _ _ __
      | | | | | | (_| | (__| (_) \___ \  \___ \ / _ \ __| | | | '_ \
      |_| |_| |_|\__,_|\___|\___/|____/  |____/ \___|\__|\__,_| .__/
                                                              |_|

           Automated macOS Development Environment Setup

=========================================================================
EOF

    while true
    do
        echo "Would you like to start? [y/n]"
        read -r USER_ANSWER

        if [[ "$USER_ANSWER" != "y" && "$USER_ANSWER" != "n" ]]
            then
                echo "Type only y or n: "
        elif [[ "$USER_ANSWER" == "y" ]]
            then

                echo ""
                echo "Initializing"
                echo "Searching for installed packages..."
                "$ROOT/scripts/setup-homebrew.sh"

                echo ""
                echo "Setting up terminal config..."
                "$ROOT/scripts/setup-terminal.sh"
                echo "Finished terminal config."

                echo ""
                echo "Setting up Git..."
                "$ROOT/scripts/setup-git.sh"
                
                echo ""
                echo "Setting up Node..."
                "$ROOT/scripts/setup-node.sh"

                echo ""
                echo "Setting up AWS CLI..."
                "$ROOT/scripts/setup-aws.sh"

                break
        elif [[ "$USER_ANSWER" == "n" ]]
            then
                echo "Exiting..."
                exit 0
        fi
    done

    echo "Would you like to setup Java or .NET environment?"
    read -r USER_ANSWER

    while true
    do
        if [[ "$USER_ANSWER" != "y" && "$USER_ANSWER" != "n" ]]
            then
                echo "Type only y or n: "
                read -r USER_ANSWER
        elif [[ "$USER_ANSWER" == "y" ]]
            then
                echo "Select the environment: "
                echo "1. Java       2. .NET       3. Both: "
                read -r OPTION
                while true
                do
                    if [[ "$OPTION" != 1 && "$OPTION" != 2 && "$OPTION" != 3 ]]
                    then
                        echo "Type 1, 2 or 3:"
                        read -r OPTION
                    elif [[ "$OPTION" == 1 ]]
                    then
                        echo "Setting up Java environment..."
                        "$ROOT/scripts/setup-java.sh"
                        break
                    elif [[ "$OPTION" == 2 ]]
                    then
                        echo "Setting up .NET environment..."
                        "$ROOT/scripts/setup-dotnet.sh"
                        break
                    elif [[ "$OPTION" == 3 ]]
                    then
                        echo "Setting up both environments..."
                        BOTH_OPTION=1
                        export BOTH_OPTION
                        "$ROOT/scripts/setup-java.sh"
                        break
                    fi
                done   
        elif [[ "$USER_ANSWER" == "n" ]]
        then
            echo "Exiting..."
            break
        fi
        break
    done

    echo "Would you like to setup your SSH key?"
    read -r USER_ANSWER

    while true
    do
        if [[ "$USER_ANSWER" != "y" && "$USER_ANSWER" != "n" ]]
                then
                    echo "Type only y or n: "
                    read -r USER_ANSWER
            elif [[ "$USER_ANSWER" == "y" ]]
            then
                echo "What is the e-mail to link to the SSH Key?"
                read -r USER_EMAIL
                export USER_EMAIL
                "$ROOT/scripts/setup-ssh.sh"
                break
            elif [[ "$USER_ANSWER" == "n" ]]
            then
                echo "You can do this process later."
                echo "Run ./scripts/setup-ssh.sh yourmail@email.com"
                echo "Finishing..."
                break
        fi
    done

    "$ROOT/scripts/update.sh"
    "$ROOT/scripts/cleanup.sh"

    echo ""
    echo "================================="
    echo "========== Completed! ==========="
    echo "================================="
                    

}
main