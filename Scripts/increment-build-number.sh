#!/bin/bash

set -e

cd "${PROJECT_DIR:-${SRCROOT:-.}}"

if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "warning: no Git repository found"
    exit 0
fi

BUILD_NUMBER=$(git rev-list --count HEAD)

if [ -z "$BUILD_NUMBER" ] || [ "$BUILD_NUMBER" -lt 1 ]; then
    echo "warning: could not determine the Git commit count"
    exit 0
fi

echo "Build number should be: ${BUILD_NUMBER} (based on ${BUILD_NUMBER} Git commits)"
