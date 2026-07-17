#!/usr/bin/env bash

main() {

    cat << "EOF"
    _   _ _____ _____   ____  _____ _____ _   _ ____  
   | \ | | ____|_   _| / ___|| ____|_   _| | | |  _ \ 
   |  \| |  _|   | |   \___ \|  _|   | | | | | | |_) |
  _| |\  | |___  | |    ___) | |___  | | | |_| |  __/ 
 (_)_| \_|_____| |_|   |____/|_____| |_|  \___/|_|    
                                                                                                       
EOF

    echo "Installed .NET SDKs:"
    dotnet --list-sdks

    echo
    echo "Installed .NET Runtimes:"
    dotnet --list-runtimes

}