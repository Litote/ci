#!/usr/bin/env bash
# Usage: set-jvm-args.sh <jvm args> [gradle.properties]
# Writes org.gradle.jvmargs to the properties file as is: Gradle reads it as Java properties, where \ escapes the next
# character. The line is replaced when it exists, added otherwise: the value is never lost without a word.
# Works with GNU and BSD sed
set -euo pipefail

JVM_ARGS="$1"
FILE="${2:-gradle.properties}"

if [[ -f "$FILE" ]] && grep -q '^org\.gradle\.jvmargs=' "$FILE"; then
  # \, & and the | delimiter are special in the replacement of sed. -i.bak: GNU and BSD sed disagree on -i without
  # a suffix
  ESCAPED=$(printf '%s' "$JVM_ARGS" | sed 's/[\\&|]/\\&/g')
  sed -i.bak "s|^org\.gradle\.jvmargs=.*|org.gradle.jvmargs=${ESCAPED}|" "$FILE"
  rm -- "$FILE.bak"
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
