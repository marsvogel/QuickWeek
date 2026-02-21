#!/bin/bash
# Setzt die Build-Nummer automatisch basierend auf Git-Commits
#
# HINWEIS: Das eigentliche Script ist inline in der Xcode Build Phase
# "Build-Nummer setzen" hinterlegt (project.pbxproj), weil die
# Script-Sandbox keinen Zugriff auf externe Dateien erlaubt.
#
# Dieses Script dient nur als Referenz und für manuelle Ausführung:
#   PROJECT_DIR="$(pwd)" bash Scripts/increment-build-number.sh

set -e

cd "${PROJECT_DIR:-${SRCROOT:-.}}"

if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "warning: Kein Git-Repository gefunden"
    exit 0
fi

BUILD_NUMBER=$(git rev-list --count HEAD)

if [ -z "$BUILD_NUMBER" ] || [ "$BUILD_NUMBER" -lt 1 ]; then
    echo "warning: Konnte Git-Commit-Anzahl nicht ermitteln"
    exit 0
fi

echo "Aktuelle Build-Nummer sollte sein: ${BUILD_NUMBER} (basierend auf ${BUILD_NUMBER} Git-Commits)"
