#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Running test suite..."
"$SCRIPT_DIR/test_setup_dotnet.sh"
echo ""
"$SCRIPT_DIR/test_setup_ssh.sh"
echo ""
echo "All test suites completed successfully!"
