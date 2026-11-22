#!/usr/bin/env bash

ROOT="${ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"

main () {
    echo ""
    echo "Setting up terminal environment..."
    install_oh_my_zsh
    install_zsh_plugins
    link_terminal_configs
    setup_vimrc
    setup_zshrc
    echo "Terminal setup completed!"
}

install_oh_my_zsh () {
    local omz_dir="$HOME/.oh-my-zsh"

    if [[ ! -d "$omz_dir" ]]; then
        echo "Installing Oh My Zsh..."
        RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    else
        echo "Oh My Zsh already installed."
    fi
}

install_zsh_plugins () {
    local custom_plugins_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        return 0
    fi

    mkdir -p "$custom_plugins_dir"

    if [[ ! -d "$custom_plugins_dir/zsh-autosuggestions" ]]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions "$custom_plugins_dir/zsh-autosuggestions"
        echo "Installed zsh-autosuggestions plugin."
    fi

    if [[ ! -d "$custom_plugins_dir/zsh-syntax-highlighting" ]]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$custom_plugins_dir/zsh-syntax-highlighting"
        echo "Installed zsh-syntax-highlighting plugin."
    fi
}

link_terminal_configs () {
    local config_dir="$HOME/.config/terminal"
    mkdir -p "$config_dir"

    if [[ -f "$ROOT/terminal/exports.sh" ]]; then
        ln -sf "$ROOT/terminal/exports.sh" "$config_dir/exports.sh"
        echo "Linked $config_dir/exports.sh"
    fi

    if [[ -f "$ROOT/terminal/aliases.sh" ]]; then
        ln -sf "$ROOT/terminal/aliases.sh" "$config_dir/aliases.sh"
        echo "Linked $config_dir/aliases.sh"
    fi
}

setup_vimrc () {
    local target_vimrc="$HOME/.vimrc"
    local source_vimrc="$ROOT/terminal/.vimrc"

    if [[ -f "$source_vimrc" ]]; then
        if [[ -f "$target_vimrc" && ! -L "$target_vimrc" ]]; then
            cp "$target_vimrc" "${target_vimrc}.backup"
            echo "Backed up existing ~/.vimrc to ~/.vimrc.backup"
        fi
        ln -sf "$source_vimrc" "$target_vimrc"
        echo "Linked $target_vimrc"
    fi
}

setup_zshrc () {
    local target_zshrc="$HOME/.zshrc"
    local source_zshrc="$ROOT/terminal/.zshrc"

    if [[ ! -f "$target_zshrc" && -f "$source_zshrc" ]]; then
        cp "$source_zshrc" "$target_zshrc"
        echo "Created ~/.zshrc from template."
    elif [[ -f "$target_zshrc" ]]; then
        echo "Found existing ~/.zshrc."

        local source_exports_line='[[ -f "$HOME/.config/terminal/exports.sh" ]] && source "$HOME/.config/terminal/exports.sh"'
        local source_aliases_line='[[ -f "$HOME/.config/terminal/aliases.sh" ]] && source "$HOME/.config/terminal/aliases.sh"'

        local modified=false

        if ! grep -Fq "terminal/exports.sh" "$target_zshrc"; then
            echo "" >> "$target_zshrc"
            echo "# Personal config" >> "$target_zshrc"
            echo "$source_exports_line" >> "$target_zshrc"
            modified=true
        fi

        if ! grep -Fq "terminal/aliases.sh" "$target_zshrc"; then
            echo "$source_aliases_line" >> "$target_zshrc"
            modified=true
        fi

        if [[ "$modified" == true ]]; then
            echo "Added personal config sourcing to ~/.zshrc."
        else
            echo "Terminal configs already sourced in ~/.zshrc. Kept unchanged."
        fi
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
