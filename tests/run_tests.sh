#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "Running syntax validation across all shell scripts..."
for script in "$REPO_ROOT/install.sh" "$REPO_ROOT"/scripts/*.sh "$REPO_ROOT"/lang/*.sh "$REPO_ROOT"/terminal/*.sh; do
    bash -n "$script"
done
echo "PASS: all shell scripts have valid syntax"
echo ""

echo "Running test suite..."
"$SCRIPT_DIR/test_install.sh"
echo ""
"$SCRIPT_DIR/test_setup_dotnet.sh"
echo ""
"$SCRIPT_DIR/test_setup_ssh.sh"
echo ""
"$SCRIPT_DIR/test_setup_terminal.sh"
echo ""
"$SCRIPT_DIR/test_setup_git.sh"
echo ""
echo "All test suites completed successfully!"

