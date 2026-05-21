#!/bin/bash
# Run Neovim configuration tests
# Usage: ./tests/run_tests.sh

set -e

echo "Running Neovim config tests..."
echo ""

# Run tests in headless mode
nvim --headless -u tests/minimal_init.lua -l tests/test_config.lua

exit_code=$?

if [ $exit_code -ne 0 ]; then
    echo ""
    echo "Tests FAILED. Fix errors before committing."
    exit 1
fi

echo ""
echo "All checks passed."
exit 0
