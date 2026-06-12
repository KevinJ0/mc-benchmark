#!/bin/bash
set -e

MODS_DIR="$(dirname "$0")/../benchmark-mod/run/mods"
mkdir -p "$MODS_DIR"

BASE_URL="https://edge.forgecdn.net/files"

echo "Downloading mods to $MODS_DIR ..."

# When Dungeons Arise (Forge 1.20.1)
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

echo "Mods downloaded:"
ls -lh "$MODS_DIR/"
