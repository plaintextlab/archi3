#!/usr/bin/env bash
# brightness.sh - step screen brightness up/down via xrandr
# Usage: brightness.sh up|down [step]
# Requires: xrandr, bc

set -euo pipefail

DIRECTION="${1:-}"
STEP="${2:-0.05}"
MIN="0.10"
MAX="1.00"

if [[ "$DIRECTION" != "up" && "$DIRECTION" != "down" ]]; then
    echo "Usage: $0 up|down [step]" >&2
    exit 1
fi

mapfile -t OUTPUTS < <(xrandr --query | grep " connected" | cut -d ' ' -f1)

for OUTPUT in "${OUTPUTS[@]}"; do
    CURRENT=$(xrandr --verbose --output "$OUTPUT" | grep -m1 "Brightness" | awk '{print $2}')
    CURRENT="${CURRENT:-1.0}"

    if [[ "$DIRECTION" == "up" ]]; then
        NEW=$(echo "$CURRENT + $STEP" | bc -l)
    else
        NEW=$(echo "$CURRENT - $STEP" | bc -l)
    fi

    # clamp to [MIN, MAX]
    NEW=$(echo "if ($NEW > $MAX) $MAX else $NEW" | bc -l)
    NEW=$(echo "if ($NEW < $MIN) $MIN else $NEW" | bc -l)
    NEW=$(printf "%.2f" "$NEW")

    xrandr --output "$OUTPUT" --brightness "$NEW"

    # optional: comment this out if you don't want notifications
    command -v notify-send >/dev/null && \
        notify-send -h string:x-canonical-private-synchronous:brightness \
        "Brightness ($OUTPUT)" "$(printf '%.0f' "$(echo "$NEW * 100" | bc -l)")%"
done
