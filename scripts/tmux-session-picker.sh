#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/skim-themes.sh"

list_sessions() {
    tmux list-sessions -F '#{?session_attached,,#{session_activity},#{session_name}}' \
        | sort -r \
        | sed '/^$/d' \
        | cut -d',' -f2-
}

selected=$(list_sessions | fzf "${SKIM_THEME_SESSION[@]}" \
    --header ' jump-to-session  (ctrl-x to kill)' \
    --preview 'tmux capture-pane -pt {}' \
    --preview-window right:60%,border-left \
    --bind "ctrl-x:execute-silent(tmux kill-session -t {})+reload($(declare -f list_sessions); list_sessions)")

[[ $selected ]] && tmux switch-client -t "$selected"
