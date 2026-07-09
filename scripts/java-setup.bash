#!/usr/bin/env bash

echo ""
echo "Configurando o ambiente JAVA"

echo "JDKs instaladas:"
/usr/libexec/java_home -V

if ! brew list --cask zulu@8 &> /dev/null
then
    echo "Zulu 8 não encontrado."
    while true
    do
        echo "Deseja instalar o Zulu 8? (s/n)"
        read INSTALL_ZULU

        if [["$INSTALL_ZULU" != "s" && "$INSTALL_ZULU" !="n"]]
        then
            echo "Digite apenas s ou n."
        elif [[ "$INSTALL_ZULU" == "s" ]]
             then
                brew install --cask zulu@8
                break
        else
            echo "Prosseguindo..."
            break
        fi
    done
else
    echo "Zulu 8 já instalado."
fi

brew install bash
curl -s "https://get.sdkman.io" | /opt/homebrew/bin/bash


source "$HOME/.zshrc"

echo ""
echo "Versão da JDK \n"
javac --version
echo "Versão do SDK"
sdk --version

echo ""
echo "==========================="
echo "========== Fim! ==========="
echo "==========================="