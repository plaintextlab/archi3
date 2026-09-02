#!/usr/bin/env bash
# brightness.sh - step screen brightness up/down via xrandr
# Usage: brightness.sh up|down [step]
# Requires: xrandr, bc
#
# NOTE: some drivers (notably NVIDIA proprietary) don't report the
# current --brightness value in `xrandr --verbose`, so we track state
# ourselves instead of reading it back.

set -uo pipefail

DIRECTION="${1:-}"
STEP="${2:-0.05}"
MIN="0.10"
MAX="1.00"
STATE_FILE="$HOME/.cache/i3_brightness_state"

if [[ "$DIRECTION" != "up" && "$DIRECTION" != "down" ]]; then
    echo "Usage: $0 up|down [step]" >&2
    exit 1
fi

CURRENT=$(cat "$STATE_FILE" 2>/dev/null || echo "1.00")

if [[ "$DIRECTION" == "up" ]]; then
    NEW=$(echo "$CURRENT + $STEP" | bc -l)
else
    NEW=$(echo "$CURRENT - $STEP" | bc -l)
fi

# clamp to [MIN, MAX]
NEW=$(echo "if ($NEW > $MAX) $MAX else $NEW" | bc -l)
NEW=$(echo "if ($NEW < $MIN) $MIN else $NEW" | bc -l)
NEW=$(printf "%.2f" "$NEW")

echo "$NEW" > "$STATE_FILE"

mapfile -t OUTPUTS < <(xrandr --query | grep " connected" | cut -d ' ' -f1)

for OUTPUT in "${OUTPUTS[@]}"; do
    xrandr --output "$OUTPUT" --brightness "$NEW"
done

command -v notify-send >/dev/null && \
    notify-send -h string:x-canonical-private-synchronous:brightness \
    "Brightness" "$(printf '%.0f' "$(echo "$NEW * 100" | bc -l)")%"