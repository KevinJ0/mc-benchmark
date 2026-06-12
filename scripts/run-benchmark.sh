#!/bin/bash
set -e

echo "Launching Minecraft benchmark..."

cd "$HOME"

# Launch Prism with the benchmark instance
# The benchmark mod will auto-start on world join:
#   5s (100 ticks) world load
#   30s (600 ticks) rotating 360°
#   35s total, then exits Minecraft
/opt/prismlauncher/bin/prismlauncher \
    --launch BenchmarkTest \
    --no-thunder \
    --no-shell \
    2>&1 | tee /tmp/prism-output.log

echo "Minecraft exited."

# The benchmark mod writes fps_log.csv to the instance's .minecraft dir
INSTANCE_DIR="$HOME/.local/share/PrismLauncher/instances/BenchmarkTest"
WORKSPACE="$(dirname "$0")/.."
if [ -f "$INSTANCE_DIR/.minecraft/fps_log.csv" ]; then
    cp "$INSTANCE_DIR/.minecraft/fps_log.csv" "$WORKSPACE/fps_log.csv"
    echo "fps_log.csv copied to workspace"
else
    echo "WARNING: fps_log.csv not found in $INSTANCE_DIR/.minecraft/"
    ls -la "$INSTANCE_DIR/.minecraft/" 2>/dev/null || echo "Instance dir not found"
fi
