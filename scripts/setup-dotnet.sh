#!/usr/bin/env bash

main() {

    cat << "EOF"
    _   _ _____ _____   ____  _____ _____ _   _ ____  
   | \ | | ____|_   _| / ___|| ____|_   _| | | |  _ \ 
   |  \| |  _|   | |   \___ \|  _|   | | | | | | |_) |
  _| |\  | |___  | |    ___) | |___  | | | |_| |  __/ 
 (_)_| \_|_____| |_|   |____/|_____| |_|  \___/|_|    
                                                                                                       
EOF
    if ! command -v dotnet &> /dev/null
    then 
        echo "Setting up .NET environment..."
        dotnet_install
        echo ".NET installed!"
        dotnet --version
    else
        echo "Installed .NET SDKs:"
        dotnet --list-sdks
        echo "Installed .NET Runtimes:"
        dotnet --list-runtimes
    fi
        
}

dotnet_install() {
    brew install dotnet
}

main