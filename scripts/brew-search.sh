#!/bin/bash
# Search Homebrew formulae (or casks) from formulae.brew.sh in fzf.
# Usage: brew-search.sh [--cask] [query]
# Prints the selected name(s) to stdout. Tab selects multiple.
set -euo pipefail

SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
source "$(dirname "$SCRIPT_PATH")/skim-themes.sh"

preview_item() {
    local kind=$1 name=$2
    local item_file="${cache_dir}/${kind}-${name}"
    [[ -f $item_file ]] || curl -fsSL "https://formulae.brew.sh/api/${kind}/${name}.json" |
        jq -r '
            "\(.name // .token)  \(.versions.stable // .version // "")",
            "",
            (.desc // ""),
            (.homepage // ""),
            "",
            (if .license then "License: \(.license)" else empty end),
            (if (.dependencies // []) | length > 0 then "Deps: \(.dependencies | join(", "))" else empty end)
        ' >"$item_file" 2>&1
    cat "$item_file"
}

kind=formula
if [[ "${1:-}" == "--preview" ]]; then
    preview_item "$2" "$3"
    exit 0
fi
if [[ "${1:-}" == "--cask" ]]; then
    kind=cask
    shift
fi

export cache_dir=$(mktemp -d)
trap 'rm -rf "$cache_dir"' EXIT

index_dir="${XDG_CACHE_HOME:-$HOME/.cache}/brew-search"
index="$index_dir/$kind.tsv"
mkdir -p "$index_dir"

# Refresh the cached index if missing or older than a day.
if [[ ! -s $index || -n $(find "$index" -mmin +1440 2>/dev/null) ]]; then
    echo "Fetching $kind index from formulae.brew.sh..." >&2
    if [[ $kind == formula ]]; then
        filter='.[] | [.name, (.desc // "")] | @tsv'
    else
        filter='.[] | [.token, (.desc // .name[0] // "")] | @tsv'
    fi
    curl -fsSL "https://formulae.brew.sh/api/$kind.json" | jq -r "$filter" >"$index.tmp"
    mv "$index.tmp" "$index"
fi

selected=$(fzf "${SKIM_THEME_SESSION[@]}" \
    --multi \
    --delimiter='\t' \
    --with-nth=1,2 \
    --query "${1:-}" \
    --border-label=" brew $kind " \
    --border-label-pos=18 \
    --bind "ctrl-o:execute-silent(open https://formulae.brew.sh/$kind/{1})" \
    --preview "$SCRIPT_PATH --preview $kind {1}" \
    --preview-window right:60%,border-left <"$index")

[[ -z $selected ]] && exit 0

cut -f1 <<<"$selected"
