#!/usr/bin/env bash

# ==================================================
# ================= setup-aws.sh ====================
# ==================================================
# Description:
# Sets up the initial AWS CLI config.
# Creates the ~/.aws directory and copies the template files
# to manual completion.
# ==================================================


AWS_DIR="$HOME/.aws"
SOURCE_DIR="$(dirname "$0")/../templates/aws"


echo "Setting up the AWS CLI..."


# Verifies if AWS CLI is already installed 

if ! command -v aws &> /dev/null; then
    echo "AWS CLI not found."
    echo "Installing..."
    brew install awscli
fi


# Creates AWS directory

mkdir -p "$AWS_DIR"


# Copies template models

if [[ ! -f "$AWS_DIR/credentials" && -f "$SOURCE_DIR/credentials.example" ]]; then
    cp "$SOURCE_DIR/credentials.example" "$AWS_DIR/credentials"
else
    if [[ -f "$AWS_DIR/credentials" ]]; then
        echo "Credentials file already exists. Kept unchanged."
    fi
fi

if [[ ! -f "$AWS_DIR/config" && -f "$SOURCE_DIR/config.example" ]]; then
    cp "$SOURCE_DIR/config.example" "$AWS_DIR/config"
else
    if [[ -f "$AWS_DIR/config" ]]; then
        echo "Credentials file already exists. Kept unchanged."
    fi
fi


echo ""
echo "AWS CLI structure created."
echo ""
echo "Now edit the files at:"
echo ""
echo "$AWS_DIR/credentials"
echo "$AWS_DIR/config"
echo ""
echo "Replace the template values with your AWS credentials"
echo ""
echo "After the setup, validate with:"
echo ""
echo "aws sts get-caller-identity"
echo ""