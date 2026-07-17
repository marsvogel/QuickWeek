#!/bin/bash
# Sets the build number automatically from the number of Git commits.
#
# NOTE: The script that actually runs is inlined into the Xcode build phase
# "Set build number" (project.pbxproj), because the build sandbox does not
# allow reading external files.
#
# This file is kept only as a reference and for manual invocation:
#   PROJECT_DIR="$(pwd)" bash Scripts/increment-build-number.sh

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
