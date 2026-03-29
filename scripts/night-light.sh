#!/usr/bin/env bash
# =============================================================================
# night_light.sh — Auto Night Light using redshift (Linux)
# =============================================================================
# Applies warm color temperature from 6 PM to 6 AM, neutral during the day.
#
# Requirements:
#   sudo apt install redshift   OR   sudo dnf install redshift
#
# Usage:
#   ./night_light.sh              # apply based on current time
#   ./night_light.sh --status     # show current state
#   ./night_light.sh --force-on   # force night light on
#   ./night_light.sh --force-off  # force night light off
#
# Auto-run every 30 minutes via crontab:
#   */30 * * * * /path/to/night_light.sh >> /tmp/night_light.log 2>&1
# =============================================================================

# --------------------------------------------------------------------------- #
#  Configuration
# --------------------------------------------------------------------------- #
NIGHT_START=18      # 6 PM (24-hour)
NIGHT_END=6         # 6 AM (24-hour)

NIGHT_TEMP=3500     # Warm night temperature in Kelvin (lower = warmer)
DAY_TEMP=6500       # Neutral day temperature in Kelvin

# --------------------------------------------------------------------------- #
#  Helpers
# --------------------------------------------------------------------------- #
NOW_HOUR=$(date +%-H)

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"; }

is_night_time() {
    if (( NIGHT_START > NIGHT_END )); then
        # Spans midnight: on if hour >= START or hour < END
        (( NOW_HOUR >= NIGHT_START || NOW_HOUR < NIGHT_END ))
    else
        (( NOW_HOUR >= NIGHT_START && NOW_HOUR < NIGHT_END ))
    fi
}

check_redshift() {
    if ! command -v redshift &>/dev/null; then
        log "ERROR: 'redshift' not found. Install with: sudo apt install redshift"
        exit 1
    fi
}

apply_redshift() {
    local temp="$1"
    pkill -x redshift 2>/dev/null || true
    sleep 0.3
    redshift -O "$temp" -P &>/dev/null &
    log "Applied color temperature: ${temp}K"
}

# --------------------------------------------------------------------------- #
#  Main
# --------------------------------------------------------------------------- #
check_redshift

case "${1:-}" in
    --status)
        echo "======================================="
        echo "  Night Light Status"
        echo "======================================="
        echo "  Current time : $(date '+%H:%M:%S')"
        echo "  Night window : ${NIGHT_START}:00 -> ${NIGHT_END}:00"
        if is_night_time; then
            echo "  Period       : NIGHT  (temp: ${NIGHT_TEMP}K)"
        else
            echo "  Period       : DAY    (temp: ${DAY_TEMP}K)"
        fi
        echo "======================================="
        ;;
    --force-on)
        log "Forcing night light ON (${NIGHT_TEMP}K)"
        apply_redshift "$NIGHT_TEMP"
        ;;
    --force-off)
        log "Forcing night light OFF (${DAY_TEMP}K)"
        apply_redshift "$DAY_TEMP"
        ;;
    "")
        log "Current hour: ${NOW_HOUR} | Night window: ${NIGHT_START}:00-${NIGHT_END}:00"
        if is_night_time; then
            log "Night time -- turning night light ON"
            apply_redshift "$NIGHT_TEMP"
        else
            log "Day time -- turning night light OFF"
            apply_redshift "$DAY_TEMP"
        fi
        ;;
    *)
        echo "Usage: $0 [--status | --force-on | --force-off]"
        exit 1
        ;;
esac
