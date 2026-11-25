#!/usr/bin/env bash
# Usage: set-jvm-args.sh <jvm args> [gradle.properties]
# Writes org.gradle.jvmargs to the properties file as is: Gradle reads it as Java properties, where \ escapes the next
# character. The line is replaced when it exists, added otherwise: the value is never lost without a word.
# Works with GNU and BSD tools
set -euo pipefail

JVM_ARGS="$1"
FILE="${2:-gradle.properties}"

if [[ -f "$FILE" ]] && grep -q '^org\.gradle\.jvmargs=' "$FILE"; then
  # awk rather than sed: the value comes from ENVIRON, which no character escapes, and the continuation lines of the
  # old value (after an odd number of \ at the end of the line) are removed, so they do not turn into other keys
  JVM_ARGS="$JVM_ARGS" awk '
    continued { continued = /(^|[^\\])(\\\\)*\\$/; next }
    /^org\.gradle\.jvmargs=/ {
      print "org.gradle.jvmargs=" ENVIRON["JVM_ARGS"]
      continued = /(^|[^\\])(\\\\)*\\$/
      next
    }
    { print }
  ' "$FILE" > "$FILE.tmp"
  # cat rather than mv: the file keeps its permissions
  cat "$FILE.tmp" > "$FILE"
  rm -- "$FILE.tmp"
else
  # Also when the key is written another way, such as with spaces around =: the last one wins in Java properties
  if [[ -s "$FILE" && -n "$(tail -c 1 -- "$FILE")" ]]; then
    echo >> "$FILE"
  fi
  printf 'org.gradle.jvmargs=%s\n' "$JVM_ARGS" >> "$FILE"
fi

if ! grep -qxF -- "org.gradle.jvmargs=$JVM_ARGS" "$FILE"; then
  echo "::error::org.gradle.jvmargs could not be written to $FILE"
  exit 1
fi
