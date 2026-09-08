#!/usr/bin/env bash
set -euo pipefail

# Validate a generated Gradle Java project.
#
# Usage:
#   ./scripts/validate-project.sh
#
# Environment:
#   RUN_E2E=true   Run e2eTest when the task exists.
#   RUN_DOCKER=true Build Docker image when Dockerfile exists.
#   RUN_NATIVE=true Attempt native build only when the project defines a native task.

if [[ ! -f "./gradlew" ]]; then
  echo "ERROR: ./gradlew was not found. Run this script from the project root." >&2
  exit 2
fi

chmod +x ./gradlew

run_gradle() {
  echo
  echo ">>> ./gradlew $*"
  ./gradlew "$@"
}

run_gradle clean build
run_gradle test

if ./gradlew tasks --all | grep -qE '(^|[[:space:]])integrationTest([[:space:]]|$)'; then
  run_gradle integrationTest
fi

run_gradle quality

if [[ "${RUN_E2E:-false}" == "true" ]] && ./gradlew tasks --all | grep -qE '(^|[[:space:]])e2eTest([[:space:]]|$)'; then
  run_gradle e2eTest
fi

if [[ "${RUN_DOCKER:-false}" == "true" && -f "Dockerfile" ]]; then
  if ! command -v docker >/dev/null 2>&1; then
    echo "ERROR: Docker requested but docker is not installed." >&2
    exit 3
  fi
  echo
  echo ">>> docker build"
  docker build -t java-project-bootstrapper-validation:local .
fi

if [[ "${RUN_NATIVE:-false}" == "true" ]]; then
  if ./gradlew tasks --all | grep -qE 'native|buildNative'; then
    echo
    echo "Native tasks detected. Run the framework-specific native build explicitly"
    echo "after verifying the required native toolchain is installed."
  else
    echo "No native build task detected; skipping native validation."
  fi
fi

echo
echo "Validation completed successfully."
