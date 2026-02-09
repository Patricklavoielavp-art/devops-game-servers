#!/usr/bin/env bash
set -euo pipefail

echo "Running shfmt..."
if command -v shfmt >/dev/null 2>&1; then
  find . -name '*.sh' -not -path './.github/*' -print0 | xargs -0 shfmt -w -i 2 || true
else
  echo "shfmt not installed, skipping format"
fi

echo "Running shellcheck..."
if command -v shellcheck >/dev/null 2>&1; then
  find . -name '*.sh' -not -path './.github/*' -print0 | xargs -0 shellcheck
else
  echo "shellcheck not installed, please install it"
  exit 1
fi

echo "Shell linting complete."
