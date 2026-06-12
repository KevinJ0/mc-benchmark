#!/bin/bash
set -e

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
INSTANCE_DIR="$HOME/.local/share/PrismLauncher/instances/BenchmarkTest"
MODS_DIR="$INSTANCE_DIR/.minecraft/mods"
mkdir -p "$MODS_DIR"
mkdir -p "$INSTANCE_DIR/.minecraft"

BASE_URL="https://edge.forgecdn.net/files"

echo "Downloading mods..."

# When Dungeons Arise (Forge 1.20.1) - no deps
wget -q "$BASE_URL/4983/862/DungeonsArise-1.20.x-2.1.58-release.jar" \
     -O "$MODS_DIR/dungeons-arise.jar"

# Epic Fight (base)
wget -q "$BASE_URL/8049/910/epic-fight-20.14.17-mc1.20.1-forge.jar" \
     -O "$MODS_DIR/epic-fight.jar"

# Epic Fight - Invincible Lib
wget -q "$BASE_URL/8041/42/invincible-20.14.7.6-mc1.20.1-forge.jar" \
     -O "$MODS_DIR/invincible-lib.jar"

# Epic Fight - Avalon
wget -q "$BASE_URL/7619/938/epic_fight_avalon-20.12.6.4.jar" \
     -O "$MODS_DIR/avalon.jar"

# EpicFight-Nightfall
wget -q "$BASE_URL/8224/805/EpicFight%20Nightfall-3.3.5.jar" \
     -O "$MODS_DIR/epicfight-nightfall.jar"

# Benchmark mod (local build)
cp "$REPO_ROOT/benchmark-mod/build/libs/"*.jar "$MODS_DIR/fps-benchmark-mod.jar"

echo "Mods deployed to $MODS_DIR"

cat > "$INSTANCE_DIR/prismlauncher.cfg" <<CFG
[General]
instanceType=OneSix
iconKey=grass
notes=

[Minecraft]
MinecraftVersion=1.20.1
modLoader=Forge
modLoaderVersion=47.3.0
CFG

echo "Instance created at $INSTANCE_DIR"
