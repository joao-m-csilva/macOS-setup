#!/usr/bin/env bash

# ==================================================
# ================= setup-aws.sh ====================
# ==================================================
# Descrição:
# Configura a estrutura inicial do AWS CLI.
# Cria o diretório ~/.aws e copia arquivos modelo
# para preenchimento manual das credenciais.
# ==================================================


AWS_DIR="$HOME/.aws"
SOURCE_DIR="$(dirname "$0")/../aws"


echo "☁️  Configurando AWS CLI..."


# Verifica se AWS CLI está instalado

if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI não encontrado."
    echo "Instale utilizando:"
    echo "brew install awscli"
    exit 1
fi


# Cria diretório AWS

mkdir -p "$AWS_DIR"


# Copia arquivos modelo

if [[ ! -f "$AWS_DIR/credentials" && -f "$SOURCE_DIR/credentials.example" ]]; then
    cp "$SOURCE_DIR/credentials.example" "$AWS_DIR/credentials"
else
    echo "Arquivo credentials já existe. Mantido sem alterações."
fi

if [[ ! -f "$AWS_DIR/config" && -f "$SOURCE_DIR/config.example" ]]; then
    cp "$SOURCE_DIR/config.example" "$AWS_DIR/config"
else
    echo "Arquivo config já existe. Mantido sem alterações."
fi


echo ""
echo "✅ Estrutura AWS CLI criada."
echo ""
echo "Agora edite os arquivos:"
echo ""
echo "$AWS_DIR/credentials"
echo "$AWS_DIR/config"
echo ""
echo "Substitua os valores de exemplo pelas suas credenciais AWS."
echo ""
echo "Após configurar, valide com:"
echo ""
echo "aws sts get-caller-identity"
echo ""