#!/bin/bash
set -euo pipefail

WORK_DIR="$HOME/Documents/Work"
CATEGORIES=(Notes People Meetings)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/skim-themes.sh"

category=$(printf '%s\n' "${CATEGORIES[@]}" | fzf "${SKIM_THEME_BASE[@]}" --prompt="Template> ")
[[ -z $category ]] && exit 0

template="$WORK_DIR/$category/template.md"
if [[ ! -f $template ]]; then
    echo "No template.md found in $WORK_DIR/$category" >&2
    exit 1
fi

name=$(find "$WORK_DIR/$category" -maxdepth 1 -type f -name '*.md' ! -name 'template.md' -exec basename {} \; \
    | fzf "${SKIM_THEME_BASE[@]}" --print-query --prompt="Name> " | head -n1) || true
[[ -z $name ]] && exit 0

slug=$(printf '%s' "$name" | tr '[:upper:]' '[:lower:]' | tr -s ' ' '-' | tr -cd 'a-z0-9-')
date_file=$(date +%F)
date_display=$(date +%d.%m.%Y)

filename="${slug}-${date_file}.md"
filepath="$WORK_DIR/$category/$filename"

if [[ -e $filepath ]]; then
    echo "File already exists: $filepath" >&2
    exit 1
fi

escaped_name=$(printf '%s' "$name" | sed -e 's/[\&/]/\\&/g')

sed -e "s/^päivä: .*/päivä: ${date_display}/" \
    -e "s/^# .*/# ${escaped_name}/" \
    "$template" > "$filepath"

"$SCRIPT_DIR/tmux-session-dispensary.sh" "$WORK_DIR"

session_name=$(basename "$WORK_DIR" | tr . _)
tmux send-keys -t "$session_name" "nvim '$filepath'" Enter
