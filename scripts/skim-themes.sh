#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/colors.sh"

# Shared fzf layout for all pickers.
SKIM_THEME_BASE=(
    --color=fg:-1,bg:-1,fg+:-1,bg+:-1,hl:${ACCENT_COLOR},hl+:${ACCENT_COLOR}:bold,pointer:${ACCENT_COLOR},marker:${ACCENT_COLOR},info:-1,prompt:-1,spinner:-1
    --height=100%
    --margin=0,0,0,0
    --layout=reverse
    --info=hidden
    --no-hscroll
    --bind=ctrl-j:down,ctrl-k:up
)

SKIM_THEME_PDF=("${SKIM_THEME_BASE[@]}")

SKIM_THEME_SESSION=("${SKIM_THEME_BASE[@]}" --scheme=path)

SKIM_THEME_LINKS=("${SKIM_THEME_BASE[@]}" --cycle)

skim_theme_flags() {
    local theme="${1:-}"
    local upper_theme="${theme^^}"
    local var_name="SKIM_THEME_${upper_theme}"
    if ! declare -p "${var_name}" >/dev/null 2>&1; then
        return 1
    fi
    local -n flags="${var_name}"
    printf '%s\n' "${flags[@]}"
}
