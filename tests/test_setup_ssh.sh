#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TARGET_SCRIPT="$REPO_ROOT/scripts/setup-ssh.sh"

test_syntax() {
    bash -n "$TARGET_SCRIPT"
    echo "PASS: syntax check"
}

test_flawed_condition_removed() {
    if grep -q '\[\[ -z "$EMAIL" || -n "$USER_EMAIL" \]\]' "$TARGET_SCRIPT"; then
        echo "FAIL: target script still contains faulty condition '[[ -z \"\$EMAIL\" || -n \"\$USER_EMAIL\" ]]'"
        exit 1
    fi
    echo "PASS: faulty condition removed"
}

test_existing_ssh_key() {
    local tmp_dir
    tmp_dir="$(mktemp -d)"

    touch "$tmp_dir/id_ed25519"
    echo "dummy-key-content" > "$tmp_dir/id_ed25519.pub"

    local pbcopy_called=0
    local keygen_called=0

    source "$TARGET_SCRIPT"
    SSH_KEY="$tmp_dir/id_ed25519"
    pbcopy() { pbcopy_called=1; }
    ssh_key_generate() { keygen_called=1; }

    main > /dev/null 2>&1

    rm -rf "$tmp_dir"

    if [[ "$pbcopy_called" -ne 1 || "$keygen_called" -ne 0 ]]; then
        echo "FAIL: existing key flow did not copy to clipboard or invoked generator"
        exit 1
    fi
    echo "PASS: handles existing ssh key by copying to clipboard"
}

test_email_from_argument() {
    local tmp_dir
    tmp_dir="$(mktemp -d)"

    local generated_email=""

    source "$TARGET_SCRIPT"
    SSH_KEY="$tmp_dir/non_existing_key"
    EMAIL="testarg@example.com"
    USER_EMAIL=""
    ssh_key_generate() { generated_email="$USER_EMAIL"; }

    main > /dev/null 2>&1

    rm -rf "$tmp_dir"

    if [[ "$generated_email" != "testarg@example.com" ]]; then
        echo "FAIL: did not use email passed in argument (got '$generated_email')"
        exit 1
    fi
    echo "PASS: uses email from argument"
}

test_email_from_env() {
    local tmp_dir
    tmp_dir="$(mktemp -d)"

    local generated_email=""

    source "$TARGET_SCRIPT"
    SSH_KEY="$tmp_dir/non_existing_key"
    EMAIL=""
    USER_EMAIL="envuser@example.com"
    ssh_key_generate() { generated_email="$USER_EMAIL"; }

    main > /dev/null 2>&1

    rm -rf "$tmp_dir"

    if [[ "$generated_email" != "envuser@example.com" ]]; then
        echo "FAIL: did not use email from environment variable (got '$generated_email')"
        exit 1
    fi
    echo "PASS: uses email from USER_EMAIL environment variable"
}

test_email_prompt_when_empty() {
    local tmp_dir
    tmp_dir="$(mktemp -d)"

    local generated_email=""

    source "$TARGET_SCRIPT"
    SSH_KEY="$tmp_dir/non_existing_key"
    EMAIL=""
    USER_EMAIL=""
    ssh_key_generate() { generated_email="$USER_EMAIL"; }

    main <<< "prompted@example.com" > /dev/null 2>&1

    rm -rf "$tmp_dir"

    if [[ "$generated_email" != "prompted@example.com" ]]; then
        echo "FAIL: did not prompt and read email when both argument and env are empty (got '$generated_email')"
        exit 1
    fi
    echo "PASS: prompts for email when argument and env are empty"
}

main_test() {
    echo "Running tests for setup-ssh.sh..."
    test_syntax
    test_flawed_condition_removed
    test_existing_ssh_key
    test_email_from_argument
    test_email_from_env
    test_email_prompt_when_empty
    echo "All tests passed for setup-ssh.sh!"
}

main_test
