#!/bin/zsh

echo "Instalando Homebrew..."

# instala Homebrew

echo "Instalando programas..."

brew bundle

echo "Instalando Node..."

./node/setup-node.sh

echo "Fim!"