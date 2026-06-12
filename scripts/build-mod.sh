#!/bin/bash
set -e

cd "$(dirname "$0")/../benchmark-mod"

if ! command -v gradle &>/dev/null; then
    echo "Installing Gradle 8.5..."
    wget -q https://services.gradle.org/distributions/gradle-8.5-bin.zip -O /tmp/gradle.zip
    unzip -q /tmp/gradle.zip -d /opt
    export PATH="/opt/gradle-8.5/bin:$PATH"
fi

echo "Building benchmark mod..."
gradle wrapper --gradle-version 8.5
./gradlew build

mkdir -p build/mods
cp build/libs/*.jar build/mods/
echo "Build done: build/mods/"
