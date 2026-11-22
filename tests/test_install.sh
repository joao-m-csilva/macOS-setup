#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TARGET_SCRIPT="$REPO_ROOT/install.sh"

test_syntax() {
    bash -n "$TARGET_SCRIPT"
    echo "PASS: syntax check"
}

test_select_language_en_us() {
    export ROOT="$REPO_ROOT"
    export SETUP_LANG="1"

    source "$TARGET_SCRIPT"
    select_language

    if [[ "${MSG_START_PROMPT:-}" != "Would you like to start? [y/n]" ]]; then
        echo "FAIL: did not load en-US messages (got '${MSG_START_PROMPT:-}')"
        exit 1
    fi
    echo "PASS: loads en-US language bundle"
}

test_select_language_pt_br() {
    export ROOT="$REPO_ROOT"
    export SETUP_LANG="pt-BR"

    source "$TARGET_SCRIPT"
    select_language

    if [[ "${MSG_START_PROMPT:-}" != "Deseja iniciar a instalacao? [y/n]" ]]; then
        echo "FAIL: did not load pt-BR messages (got '${MSG_START_PROMPT:-}')"
        exit 1
    fi
    echo "PASS: loads pt-BR language bundle"
}

main_test() {
    echo "Running tests for install.sh..."
    test_syntax
    test_select_language_en_us
    test_select_language_pt_br
    echo "All tests passed for install.sh!"
}

main_test
