#!/usr/bin/env bash

ROOT="${ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"

main () {
    echo ""
    echo "Setting up terminal environment..."
    copy_terminal_configs
    setup_zshrc
    echo "Terminal setup completed!"
}

copy_terminal_configs () {
    local config_dir="$HOME/.config/terminal"
    mkdir -p "$config_dir"

    if [[ -f "$ROOT/terminal/exports.sh" ]]; then
        cp "$ROOT/terminal/exports.sh" "$config_dir/exports.sh"
        echo "Updated $config_dir/exports.sh"
    fi

    if [[ -f "$ROOT/terminal/aliases.sh" ]]; then
        cp "$ROOT/terminal/aliases.sh" "$config_dir/aliases.sh"
        echo "Updated $config_dir/aliases.sh"
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

main