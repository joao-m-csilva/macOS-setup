#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TARGET_SCRIPT="$REPO_ROOT/scripts/setup-dotnet.sh"

test_syntax() {
    bash -n "$TARGET_SCRIPT"
    echo "PASS: syntax check"
}

test_command_rider_syntax() {
    if grep -q "command -v rider --version" "$TARGET_SCRIPT"; then
        echo "FAIL: target script still contains 'command -v rider --version'"
        exit 1
    fi
    if ! grep -q "command -v rider" "$TARGET_SCRIPT"; then
        echo "FAIL: target script missing 'command -v rider'"
        exit 1
    fi
    echo "PASS: rider command existence check syntax"
}

test_dotnet_missing() {
    local dotnet_installed=0
    dotnet_install() { dotnet_installed=1; }
    rider_install() { :; }
    dotnet() { :; }
    rider() { :; }

    # Override command to simulate missing dotnet
    command() {
        if [[ "$1" == "-v" && "$2" == "dotnet" ]]; then
            return 1
        fi
        builtin command "$@"
    }

    # Sourced without running main
    source "$TARGET_SCRIPT"

    # Redefine mocked dotnet_install
    dotnet_install() { dotnet_installed=1; }

    main > /dev/null 2>&1

    if [[ "$dotnet_installed" -ne 1 ]]; then
        echo "FAIL: dotnet_install was not invoked when dotnet was missing"
        exit 1
    fi
    echo "PASS: invokes dotnet_install when dotnet is missing"
}

test_dotnet_installed_rider_missing() {
    local rider_installed=0
    dotnet_install() { :; }
    rider_install() { rider_installed=1; }
    dotnet() { :; }
    rider() { :; }

    command() {
        if [[ "$1" == "-v" && "$2" == "dotnet" ]]; then
            return 0
        elif [[ "$1" == "-v" && "$2" == "rider" ]]; then
            return 1
        fi
        builtin command "$@"
    }

    source "$TARGET_SCRIPT"
    rider_install() { rider_installed=1; }

    main > /dev/null 2>&1

    if [[ "$rider_installed" -ne 1 ]]; then
        echo "FAIL: rider_install was not invoked when rider was missing"
        exit 1
    fi
    echo "PASS: invokes rider_install when dotnet is present and rider is missing"
}

test_both_installed() {
    local dotnet_installed=0
    local rider_installed=0
    dotnet() { :; }
    rider() { :; }

    command() {
        if [[ "$1" == "-v" && ("$2" == "dotnet" || "$2" == "rider") ]]; then
            return 0
        fi
        builtin command "$@"
    }

    source "$TARGET_SCRIPT"
    dotnet_install() { dotnet_installed=1; }
    rider_install() { rider_installed=1; }

    main > /dev/null 2>&1

    if [[ "$dotnet_installed" -ne 0 || "$rider_installed" -ne 0 ]]; then
        echo "FAIL: install functions should not be invoked when both tools exist"
        exit 1
    fi
    echo "PASS: does not install when both dotnet and rider are present"
}

main_test() {
    echo "Running tests for setup-dotnet.sh..."
    test_syntax
    test_command_rider_syntax
    test_dotnet_missing
    test_dotnet_installed_rider_missing
    test_both_installed
    echo "All tests passed for setup-dotnet.sh!"
}

main_test
