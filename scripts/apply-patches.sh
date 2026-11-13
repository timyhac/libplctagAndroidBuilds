#!/usr/bin/env bash
# Applies patches/*.patch to a libplctag core checkout. Skips any patch that is already
# present upstream, so the workflow keeps working once fixes land in core.
set -euo pipefail
core="$1"
here="$(cd "$(dirname "$0")/.." && pwd)"
for p in "$here"/patches/*.patch; do
  [ -f "$p" ] || continue
  if patch -d "$core" -p1 -R --dry-run -s -f < "$p" >/dev/null 2>&1; then
    echo "already upstream: $(basename "$p")"
  else
    patch -d "$core" -p1 -s < "$p"
    echo "applied: $(basename "$p")"
  fi
done
