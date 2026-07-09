#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "=========================="
echo "===== MacBook Setup ======"
echo "=========================="

echo ""
echo "Instalando Homebrew..."

if ! command -v brew &> /dev/null
then
    echo "Homebrew não encontrado. Instalando..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

else
    echo "Homebrew já instalado."
fi

eval "$(/opt/homebrew/bin/brew shellenv)"

echo ""
echo "Verficiando a versão do Git..."

if ! command -v git &> /dev/null
then
    echo "Git não encontrado. Instalando..."
    brew install git
else
    echo "Git já instalado."
    git --version
fi

echo ""
echo "Instalando programas..."

brew bundle --file="$REPO_DIR/brew/Brewfile"


echo ""
echo "Configurando Node..."

"$REPO_DIR/node/setup-node.sh"


echo ""
echo "Configurando Git global..."

cp "$REPO_DIR/git/.gitignore_global" ~/.gitignore_global

git config --global core.excludesfile ~/.gitignore_global

echo ""
echo "Configurando AWS CLI..."

./setup-aws.sh

echo ""
echo "==========================="
echo "========== Fim! ==========="
echo "==========================="