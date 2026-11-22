#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TARGET_SCRIPT="$REPO_ROOT/scripts/setup-terminal.sh"

test_syntax() {
    bash -n "$TARGET_SCRIPT"
    echo "PASS: syntax check"
}

test_link_terminal_configs_and_vimrc() {
    local tmp_home
    tmp_home="$(mktemp -d)"

    local orig_home="$HOME"
    export HOME="$tmp_home"
    export ROOT="$REPO_ROOT"

    source "$TARGET_SCRIPT"
    link_terminal_configs > /dev/null 2>&1
    setup_vimrc > /dev/null 2>&1

    if [[ ! -L "$tmp_home/.config/terminal/exports.sh" || ! -L "$tmp_home/.config/terminal/aliases.sh" ]]; then
        export HOME="$orig_home"
        rm -rf "$tmp_home"
        echo "FAIL: exports.sh or aliases.sh was not symlinked"
        exit 1
    fi

    if [[ ! -L "$tmp_home/.vimrc" ]]; then
        export HOME="$orig_home"
        rm -rf "$tmp_home"
        echo "FAIL: .vimrc was not symlinked"
        exit 1
    fi

    export HOME="$orig_home"
    rm -rf "$tmp_home"
    echo "PASS: symlinks terminal configs and .vimrc"
}

test_vimrc_backup_when_regular_file_exists() {
    local tmp_home
    tmp_home="$(mktemp -d)"

    local orig_home="$HOME"
    export HOME="$tmp_home"
    export ROOT="$REPO_ROOT"

    echo "set number" > "$tmp_home/.vimrc"

    source "$TARGET_SCRIPT"
    setup_vimrc > /dev/null 2>&1

    if [[ ! -f "$tmp_home/.vimrc.backup" || ! -L "$tmp_home/.vimrc" ]]; then
        export HOME="$orig_home"
        rm -rf "$tmp_home"
        echo "FAIL: existing .vimrc was not backed up before symlinking"
        exit 1
    fi

    export HOME="$orig_home"
    rm -rf "$tmp_home"
    echo "PASS: backs up existing regular .vimrc before symlinking"
}

test_setup_zshrc_creates_and_updates() {
    local tmp_home
    tmp_home="$(mktemp -d)"

    local orig_home="$HOME"
    export HOME="$tmp_home"
    export ROOT="$REPO_ROOT"

    source "$TARGET_SCRIPT"
    setup_zshrc > /dev/null 2>&1

    if [[ ! -f "$tmp_home/.zshrc" ]]; then
        export HOME="$orig_home"
        rm -rf "$tmp_home"
        echo "FAIL: .zshrc was not created from template"
        exit 1
    fi

    # Overwrite with a minimal custom .zshrc without personal config sourcing
    echo "export TEST_VAR=1" > "$tmp_home/.zshrc"
    setup_zshrc > /dev/null 2>&1

    if ! grep -Fq "terminal/exports.sh" "$tmp_home/.zshrc" || ! grep -Fq "terminal/aliases.sh" "$tmp_home/.zshrc"; then
        export HOME="$orig_home"
        rm -rf "$tmp_home"
        echo "FAIL: existing .zshrc was not updated with personal config sourcing"
        exit 1
    fi

    export HOME="$orig_home"
    rm -rf "$tmp_home"
    echo "PASS: creates and updates .zshrc idempotently"
}

main_test() {
    echo "Running tests for setup-terminal.sh..."
    test_syntax
    test_link_terminal_configs_and_vimrc
    test_vimrc_backup_when_regular_file_exists
    test_setup_zshrc_creates_and_updates
    echo "All tests passed for setup-terminal.sh!"
}

main_test
