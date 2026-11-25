#!/usr/bin/env bash
# Reads the patches of a pull request on stdin and prints true when it only changes the digests of the same tags,
# false otherwise. Every changed line must hold a digest, and the lines must be the same once the digests are
# removed, in the order of the diff: a moved or reordered line is not a digest bump. A file without a patch (binary,
# too large) must come as a line without a digest, such as "+no patch"
set -euo pipefail

DIGEST='@sha256:[0-9a-f]{64}'
CHANGED=$(grep -E '^[-+]' || true)
# || true: no removed or no added line is not an error, even with pipefail
REMOVED=$({ grep '^-' <<< "$CHANGED" || true; } | cut -c2- | sed -E "s/$DIGEST//")
ADDED=$({ grep '^+' <<< "$CHANGED" || true; } | cut -c2- | sed -E "s/$DIGEST//")
if [[ -n "$CHANGED" ]] && ! grep -qvE "$DIGEST" <<< "$CHANGED" && [[ "$REMOVED" == "$ADDED" ]]; then
  echo true
else
  echo false
fi
