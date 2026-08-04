#!/usr/bin/env bash

main() {

    cat << "EOF"
         _                    ____       _
        | | __ ___   ____ _  / ___|  ___| |_ _   _ _ __
     _  | |/ _` \ \ / / _` | \___ \ / _ \ __| | | | '_ \
    | |_| | (_| |\ V / (_| |  ___) |  __/ |_| |_| | |_) |
     \___/ \__,_| \_/ \__,_| |____/ \___|\__|\__,_| .__/
                                                |_|

EOF

    if ! /usr/libexec/java_home -V &> /dev/null
    then
        echo "There's no jdk version installed."
        java_install
    else
        echo "There are already installed jdk versions."
        echo "Installed JDKs:"
        /usr/libexec/java_home -V
        if [[ "$BOTH_OPTION" == 1 ]]
        then
            dotnet_install_sequence
        fi       
    fi
}

java_install() {
    while true
    do  
        echo "JDK 8 (zulu@08) will be set up as default version."
        echo "IntelliJ IDEA will be also installed."
        echo "Would you like to proceed? y/n"
        read -r USER_ANSWER

        if [[ "$USER_ANSWER" != "y" && "$USER_ANSWER" != "n" ]]
        then 
            echo "Type only y or n:"
        elif [[ "$USER_ANSWER" == "y" && "$BOTH_OPTION" != 1 ]]
        then
            echo "Setting up Java Environment..."
            brew install --cask zulu@08
            brew install --cask intellij-idea
            break
        elif [[ "$USER_ANSWER" == "y" && "$BOTH_OPTION" == 1 ]]
        then
            echo "Setting up Java and .NET environment"
            brew install --cask zulu@08 
            brew install --cask intellij-idea
            dotnet_install_sequence
            break
        elif [[ "$USER_ANSWER" == "n" ]]
        then
            echo "Would you like to install SDKMAN! to manage jdk versions? y/n"
            echo "PS: IntelliJ IDEA will not be installed."
            read -r USER_ANSWER

            while true
            do
                if [[ "$USER_ANSWER" != "y" && "$USER_ANSWER" != "n" ]]
                then
                    echo "Type only y or n:"
                    read -r USER_ANSWER
                elif [[ "$USER_ANSWER" == "y" && "$BOTH_OPTION" == 1 ]]
                then
                    bash_install
                    sdkman_install
                    dotnet_install_sequence
                    break
                elif [[ "$USER_ANSWER" == "y" && "$BOTH_OPTION" != 1 ]]
                then
                    bash_install
                    sdkman_install
                    break
                elif [[ "$USER_ANSWER" == "n" && "$BOTH_OPTION" == 1 ]]
                then
                    dotnet_install_sequence
                    break
                elif [[ "$USER_ANSWER" == "n" && "$BOTH_OPTION" != 1 ]]
                then
                    break
                fi
            done
            break
        fi
    done
}

bash_install() {
    if [[ ! -x "/opt/homebrew/bin/bash" ]]
    then
        brew install bash
    fi
}

sdkman_install() {
    if [[ ! -f "$HOME/.sdkman/bin/sdkman-init.sh" ]]
    then
        curl -s "https://get.sdkman.io" | /opt/homebrew/bin/bash
    fi
}

dotnet_install_sequence() {
    "$ROOT/scripts/setup-dotnet.sh"
}
main