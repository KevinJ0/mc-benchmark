#!/bin/bash
set -e

PROJECT_DIR="$(cd "$(dirname "$0")/../benchmark-mod" && pwd)"

if [ -f "$PROJECT_DIR/gradlew" ]; then
    echo "Gradle wrapper already exists"
    exit 0
fi

echo "Generating Gradle 8.5 wrapper from temp dir..."
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

if command -v gradle &>/dev/null; then
    gradle wrapper --gradle-version 8.5
else
    wget -q https://services.gradle.org/distributions/gradle-8.5-bin.zip -O /tmp/gradle85.zip
    unzip -q /tmp/gradle85.zip -d /opt
    /opt/gradle-8.5/bin/gradle wrapper --gradle-version 8.5
fi

cp gradlew gradlew.bat "$PROJECT_DIR/"
mkdir -p "$PROJECT_DIR/gradle/wrapper"
cp gradle/wrapper/gradle-wrapper.jar gradle/wrapper/gradle-wrapper.properties "$PROJECT_DIR/gradle/wrapper/"
chmod +x "$PROJECT_DIR/gradlew"

rm -rf "$TMP_DIR"

echo "Gradle 8.5 wrapper ready in $PROJECT_DIR"
