#!/usr/bin/env bash
set -euo pipefail

# This helper does NOT claim to resolve the complete Java/framework compatibility
# matrix. The Codex skill must use authoritative documentation and package metadata
# for that decision.
#
# It provides lightweight metadata useful during local project bootstrapping.
#
# Usage:
#   ./resolve-versions.sh
#
# Optional:
#   JAVA_MAJOR=25 ./resolve-versions.sh

JAVA_MAJOR="${JAVA_MAJOR:-}"

echo "Java project bootstrapper - environment/version helper"
echo

if command -v java >/dev/null 2>&1; then
  echo "Installed Java:"
  java -version 2>&1 | head -n 3
else
  echo "Java: not installed or not on PATH"
fi

if command -v ./gradlew >/dev/null 2>&1; then
  echo
  echo "Gradle Wrapper:"
  ./gradlew --version
elif command -v gradle >/dev/null 2>&1; then
  echo
  echo "System Gradle:"
  gradle --version
else
  echo "Gradle: wrapper/system Gradle not found"
fi

if [[ -n "$JAVA_MAJOR" ]]; then
  echo
  echo "Requested Java major: $JAVA_MAJOR"
  if ! [[ "$JAVA_MAJOR" =~ ^[0-9]+$ ]]; then
    echo "ERROR: JAVA_MAJOR must be numeric." >&2
    exit 2
  fi
  if (( JAVA_MAJOR < 21 )); then
    echo "ERROR: selected Java must be >= 21." >&2
    exit 2
  fi
fi

echo
echo "For framework/dependency versions, use current authoritative release and"
echo "compatibility documentation. Do not treat this script as a compatibility oracle."
