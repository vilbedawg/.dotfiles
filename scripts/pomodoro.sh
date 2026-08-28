#!/bin/bash
set -euo pipefail

# stop_loop() uses SIGUSR1 (not TERM) to pause/cancel intentionally, and exits
# cleanly on it so tmux's run-shell doesn't report "terminated by signal".
trap 'exit 0' USR1

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_PATH="$SCRIPT_DIR/$(basename "${BASH_SOURCE[0]}")"
source "$SCRIPT_DIR/skim-themes.sh"

WORK_OPTIONS=(
    "25 Pomodoro"
    "50 Deep work"
    "15 Short focus"
    "90 Marathon"
)

BREAK_OPTIONS=(
    "5 Short break"
    "10 Long break"
    "15 Extended break"
    "20 Long walk"
)

set_status() {
    tmux set-option -g @pomodoro_status "$1" 2>/dev/null || true
    tmux refresh-client -S 2>/dev/null || true
}

clear_status() {
    tmux set-option -gu @pomodoro_status 2>/dev/null || true
    tmux refresh-client -S 2>/dev/null || true
}

# State layout: PHASE|REMAINING|STATUS|WORK_MIN|WORK_LABEL|BREAK_MIN|BREAK_LABEL
read_state() {
    local raw
    raw=$(tmux show-options -gqv @pomodoro_state 2>/dev/null)
    [[ -n "$raw" ]] || return 1
    IFS='|' read -r PHASE REMAINING STATUS WORK_MIN WORK_LABEL BREAK_MIN BREAK_LABEL <<< "$raw"
}

write_state() {
    tmux set-option -g @pomodoro_state \
        "$(printf '%s|%s|%s|%s|%s|%s|%s' "$PHASE" "$REMAINING" "$STATUS" "$WORK_MIN" "$WORK_LABEL" "$BREAK_MIN" "$BREAK_LABEL")"
}

stop_loop() {
    local pid
    pid=$(tmux show-options -gqv @pomodoro_pid 2>/dev/null)
    if [[ -n "$pid" ]]; then
        kill -USR1 "$pid" 2>/dev/null || true
        tmux set-option -gu @pomodoro_pid 2>/dev/null || true
    fi
}

render() {
    local icon color
    if [[ "$PHASE" == work ]]; then
        icon="🍅"
    else
        icon="☕"
    fi
    local m=$((REMAINING / 60)) s=$((REMAINING % 60))
    local suffix=""
    [[ "$STATUS" == paused ]] && suffix=" (paused)"
    if [[ "$STATUS" == paused || "$PHASE" == break ]]; then
        color="$ACCENT_COLOR"
    else
        color="white"
    fi
    set_status "$(printf '#[fg=%s bold]%s %02d:%02d%s#[default]' "$color" "$icon" "$m" "$s" "$suffix")"
}

run_loop() {
    while true; do
        read_state || exit 0
        [[ "$STATUS" == running ]] || exit 0

        if (( REMAINING <= 0 )); then
            if [[ "$PHASE" == work ]]; then
                tmux display-message -d 5000 "Pomodoro done — time for a ${BREAK_LABEL}" 2>/dev/null || true
                PHASE=break
                REMAINING=$((BREAK_MIN * 60))
                write_state
                continue
            else
                tmux display-message -d 5000 "Break's over — back to it" 2>/dev/null || true
                tmux set-option -gu @pomodoro_state 2>/dev/null || true
                tmux set-option -gu @pomodoro_pid 2>/dev/null || true
                clear_status
                exit 0
            fi
        fi

        render
        sleep 1
        REMAINING=$((REMAINING - 1))
        write_state
    done
}

start_loop() {
    stop_loop
    tmux run-shell -b "$SCRIPT_PATH _loop"
}

pick() {
    local prompt="$1"; shift
    printf '%s\n' "$@" | fzf "${SKIM_THEME_BASE[@]}" --prompt="$prompt "
}

fresh_start() {
    local choice

    choice=$(pick "Work session:" "${WORK_OPTIONS[@]}") || true
    [[ -z "$choice" ]] && exit 0
    WORK_MIN=${choice%% *}
    WORK_LABEL=${choice#* }

    choice=$(pick "Then a:" "${BREAK_OPTIONS[@]}") || true
    [[ -z "$choice" ]] && exit 0
    BREAK_MIN=${choice%% *}
    BREAK_LABEL=${choice#* }

    PHASE=work
    REMAINING=$((WORK_MIN * 60))
    STATUS=running
    write_state
    render
    start_loop
}

toggle() {
    if ! read_state; then
        # No timer yet: pausing/resuming needs no UI, but picking durations
        # does, so only open a popup for this branch, not on every toggle.
        tmux display-popup -B -E -w 40% -h 40% "$SCRIPT_PATH _pick"
        return
    fi

    if [[ "$STATUS" == running ]]; then
        stop_loop
        STATUS=paused
        write_state
        render
    else
        STATUS=running
        write_state
        start_loop
    fi
}

cancel() {
    stop_loop
    tmux set-option -gu @pomodoro_state 2>/dev/null || true
    clear_status
    tmux display-message -d 5000 "Pomodoro cancelled"
}

case "${1:-toggle}" in
    toggle) toggle ;;
    cancel) cancel ;;
    _pick) fresh_start ;;
    _loop)
        tmux set-option -g @pomodoro_pid "$$"
        run_loop
        ;;
    *)
        echo "usage: $0 [toggle|cancel]" >&2
        exit 1
        ;;
esac
