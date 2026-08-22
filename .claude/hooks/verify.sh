#!/usr/bin/env bash
# Fast post-edit check on TypeScript files: blocks on typecheck errors, warns (never blocks) on lint.
set -uo pipefail

cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0

if [ ! -f package.json ]; then
  # Scaffold not built yet — nothing to check.
  exit 0
fi

pnpm typecheck
typecheck_status=$?

pnpm lint || true

if [ "$typecheck_status" -ne 0 ]; then
  echo "verify.sh: typecheck failed" >&2
  exit 1
fi

exit 0
