#!/bin/bash
set -e

cd "$(dirname "$0")/../benchmark-mod"

if [ ! -f "gradlew" ]; then
    echo "Downloading Gradle wrapper..."
    if command -v gradle &>/dev/null; then
        gradle wrapper --gradle-version 8.5
    else
        wget -q https://services.gradle.org/distributions/gradle-8.5-bin.zip -O /tmp/gradle.zip
        unzip -q /tmp/gradle.zip -d /opt
        /opt/gradle-8.5/bin/gradle wrapper --gradle-version 8.5
    fi
fi

echo "Gradle wrapper ready"
