#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TARGET_SCRIPT="$REPO_ROOT/scripts/setup-git.sh"

test_syntax() {
    bash -n "$TARGET_SCRIPT"
    echo "PASS: syntax check"
}

test_git_config_and_ignore_setup() {
    local tmp_home
    tmp_home="$(mktemp -d)"

    local orig_home="$HOME"
    export HOME="$tmp_home"
    export ROOT="$REPO_ROOT"

    source "$TARGET_SCRIPT"

    git_config_setup <<< $'Test User\ntest@example.com\n' > /dev/null 2>&1
    git_ignore_global_config > /dev/null 2>&1

    if [[ ! -f "$tmp_home/.gitconfig" || ! -f "$tmp_home/.gitignore_global" ]]; then
        export HOME="$orig_home"
        rm -rf "$tmp_home"
        echo "FAIL: .gitconfig or .gitignore_global was not created"
        exit 1
    fi

    local configured_name
    local configured_email
    configured_name="$(git config --file "$tmp_home/.gitconfig" user.name)"
    configured_email="$(git config --file "$tmp_home/.gitconfig" user.email)"

    export HOME="$orig_home"
    rm -rf "$tmp_home"

    if [[ "$configured_name" != "Test User" || "$configured_email" != "test@example.com" ]]; then
        echo "FAIL: git user.name or user.email mismatch ($configured_name / $configured_email)"
        exit 1
    fi

    echo "PASS: configures .gitconfig and .gitignore_global in isolated HOME"
}

main_test() {
    echo "Running tests for setup-git.sh..."
    test_syntax
    test_git_config_and_ignore_setup
    echo "All tests passed for setup-git.sh!"
}

main_test
