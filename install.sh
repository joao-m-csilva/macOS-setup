#!/usr/bin/env bash

set -e

ROOT="${ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
export ROOT
BOTH_OPTION=0

select_language () {
    local lang_choice="${SETUP_LANG:-}"

    if [[ -z "$lang_choice" ]]; then
        echo "Select language / Selecione o idioma:"
        echo "1. English (en-US) [default]    2. Portugues (pt-BR)"
        read -r lang_choice
    fi

    if [[ "$lang_choice" == "2" || "$lang_choice" == "pt-BR" ]]; then
        source "$ROOT/lang/pt-BR.sh"
    else
        source "$ROOT/lang/en-US.sh"
    fi
}

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

    select_language

    while true
    do
        echo "$MSG_START_PROMPT"
        read -r USER_ANSWER

        if [[ "$USER_ANSWER" != "y" && "$USER_ANSWER" != "n" ]]
            then
                echo "$MSG_ONLY_YN"
        elif [[ "$USER_ANSWER" == "y" ]]
            then

                echo ""
                echo "$MSG_INITIALIZING"
                echo "$MSG_SEARCHING_PACKAGES"
                "$ROOT/scripts/setup-homebrew.sh"

                echo ""
                echo "$MSG_SETTING_TERMINAL"
                "$ROOT/scripts/setup-terminal.sh"
                echo "$MSG_FINISHED_TERMINAL"

                echo ""
                echo "$MSG_SETTING_GIT"
                "$ROOT/scripts/setup-git.sh"
                
                echo ""
                echo "$MSG_SETTING_NODE"
                "$ROOT/scripts/setup-node.sh"

                echo ""
                echo "$MSG_SETTING_AWS"
                "$ROOT/scripts/setup-aws.sh"

                break
        elif [[ "$USER_ANSWER" == "n" ]]
            then
                echo "$MSG_EXITING"
                exit 0
        fi
    done

    echo "$MSG_JAVA_DOTNET_PROMPT"
    read -r USER_ANSWER

    while true
    do
        if [[ "$USER_ANSWER" != "y" && "$USER_ANSWER" != "n" ]]
            then
                echo "$MSG_ONLY_YN"
                read -r USER_ANSWER
        elif [[ "$USER_ANSWER" == "y" ]]
            then
                echo "$MSG_SELECT_ENV"
                echo "$MSG_ENV_OPTIONS"
                read -r OPTION
                while true
                do
                    if [[ "$OPTION" != 1 && "$OPTION" != 2 && "$OPTION" != 3 ]]
                    then
                        echo "$MSG_ONLY_123"
                        read -r OPTION
                    elif [[ "$OPTION" == 1 ]]
                    then
                        echo "$MSG_SETTING_JAVA"
                        "$ROOT/scripts/setup-java.sh"
                        break
                    elif [[ "$OPTION" == 2 ]]
                    then
                        echo "$MSG_SETTING_DOTNET"
                        "$ROOT/scripts/setup-dotnet.sh"
                        break
                    elif [[ "$OPTION" == 3 ]]
                    then
                        echo "$MSG_SETTING_BOTH"
                        BOTH_OPTION=1
                        export BOTH_OPTION
                        "$ROOT/scripts/setup-java.sh"
                        break
                    fi
                done   
        elif [[ "$USER_ANSWER" == "n" ]]
        then
            echo "$MSG_EXITING"
            break
        fi
        break
    done

    echo "$MSG_SSH_PROMPT"
    read -r USER_ANSWER

    while true
    do
        if [[ "$USER_ANSWER" != "y" && "$USER_ANSWER" != "n" ]]
                then
                    echo "$MSG_ONLY_YN"
                    read -r USER_ANSWER
            elif [[ "$USER_ANSWER" == "y" ]]
            then
                echo "$MSG_SSH_EMAIL_PROMPT"
                read -r USER_EMAIL
                export USER_EMAIL
                "$ROOT/scripts/setup-ssh.sh"
                break
            elif [[ "$USER_ANSWER" == "n" ]]
            then
                echo "$MSG_SSH_LATER"
                echo "$MSG_SSH_LATER_CMD"
                echo "$MSG_FINISHING"
                break
        fi
    done

    "$ROOT/scripts/update.sh"
    "$ROOT/scripts/cleanup.sh"

    echo ""
    echo "================================="
    echo "$MSG_COMPLETED"
    echo "================================="
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
