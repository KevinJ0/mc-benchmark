import json
import pandas as pd
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np

CSV_PATH = 'fps_log.csv'
PNG_PATH = 'benchmark_report.png'
JSON_PATH = 'benchmark_stats.json'

try:
    df = pd.read_csv(CSV_PATH)
except FileNotFoundError:
    print("ERROR: fps_log.csv not found. Was the benchmark run?")
    exit(1)

fps = df['fps'].values
free_mem = df['free_mb'].values
seconds = df['second'].values

if len(fps) < 2:
    print("ERROR: Not enough data points (< 2 seconds)")
    exit(1)

avg_fps = float(np.mean(fps))
min_fps = float(np.min(fps))
max_fps = float(np.max(fps))
median_fps = float(np.median(fps))
std_fps = float(np.std(fps))

sorted_fps = np.sort(fps)
n = len(sorted_fps)
one_pct_low = float(sorted_fps[int(n * 0.01)]) if n >= 100 else float(sorted_fps[0])
point_one_pct_low = float(sorted_fps[int(n * 0.001)]) if n >= 1000 else float(sorted_fps[0])

stats = {
    'avg_fps': round(avg_fps, 2),
    'min_fps': round(min_fps, 2),
    'max_fps': round(max_fps, 2),
    'median_fps': round(median_fps, 2),
    'std_fps': round(std_fps, 2),
    'one_pct_low': round(one_pct_low, 2),
    'point_one_pct_low': round(point_one_pct_low, 2),
    'duration_seconds': int(seconds[-1]) if len(seconds) > 0 else 0,
}

with open(JSON_PATH, 'w') as f:
    json.dump(stats, f, indent=2)

print("=== FPS Benchmark Results ===")
print(f"  Average FPS:   {avg_fps:.2f}")
print(f"  Median FPS:    {median_fps:.2f}")
print(f"  Min FPS:       {min_fps:.2f}")
print(f"  Max FPS:       {max_fps:.2f}")
print(f"  Std Dev:       {std_fps:.2f}")
print(f"  1% Low FPS:    {one_pct_low:.2f}")
print(f"  0.1% Low FPS:  {point_one_pct_low:.2f}")
print(f"  Duration:      {stats['duration_seconds']}s")
print(f"  Samples:       {n}")
print("=============================")

fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(12, 8), gridspec_kw={'height_ratios': [3, 1]})

ax1.plot(seconds, fps, color='#2196F3', linewidth=1.5, alpha=0.9)
ax1.axhline(y=avg_fps, color='#FF5722', linestyle='--', linewidth=1, label=f'Avg: {avg_fps:.1f}')
ax1.axhline(y=one_pct_low, color='#F44336', linestyle=':', linewidth=1, label=f'1% Low: {one_pct_low:.1f}')
ax1.fill_between(seconds, fps, alpha=0.15, color='#2196F3')
ax1.set_ylabel('FPS')
ax1.set_title('FPS Benchmark — When Dungeons Arise + EpicFight-Nightfall (Forge 1.20.1)', fontsize=12)
ax1.set_xlabel('Time (seconds)')
ax1.legend(fontsize=9)
ax1.grid(True, alpha=0.3)

stats_text = (
    f"Avg: {avg_fps:.1f}  |  Min: {min_fps:.1f}  |  Max: {max_fps:.1f}\n"
    f"1% Low: {one_pct_low:.1f}  |  0.1% Low: {point_one_pct_low:.1f}\n"
    f"Std Dev: {std_fps:.1f}  |  Samples: {n}  |  Duration: {stats['duration_seconds']}s"
)
ax1.text(0.02, 0.02, stats_text, transform=ax1.transAxes, fontsize=9,
         verticalalignment='bottom', bbox=dict(boxstyle='round', facecolor='wheat', alpha=0.7))

ax2.plot(seconds, free_mem, color='#4CAF50', linewidth=1.5, alpha=0.8)
ax2.fill_between(seconds, free_mem, alpha=0.15, color='#4CAF50')
ax2.set_ylabel('Free Memory (MB)')
ax2.set_xlabel('Time (seconds)')
ax2.grid(True, alpha=0.3)

plt.tight_layout()
plt.savefig(PNG_PATH, dpi=150, bbox_inches='tight')
print(f"\nReport saved: {PNG_PATH}")
print(f"Stats saved:  {JSON_PATH}")
