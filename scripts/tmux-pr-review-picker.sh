#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_PATH="$SCRIPT_DIR/$(basename "${BASH_SOURCE[0]}")"
source "$SCRIPT_DIR/skim-themes.sh"

repo_root=$(git rev-parse --show-toplevel)

cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/pr-review-picker"

preview_pr() {
    local pr_file="${cache_dir}/pr-${1}.md"

    if [[ -f $pr_file ]]; then
        cat "$pr_file"
        return
    fi

    local output
    mkdir -p "$cache_dir"
    if output=$(gh pr view "$1" --comments 2>&1); then
        printf '%s\n' "$output" | tee "$pr_file"
    else
        printf 'failed to fetch PR #%s:\n\n%s\n' "$1" "$output"
    fi
}

if [[ "${1:-}" == "--preview-pr" ]]; then
    preview_pr "$2"
    exit 0
fi

prs=$(gh pr list --json number,title,author,headRefName \
    --template '{{range .}}{{.number}}{{"\t"}}{{.title}}{{"\t"}}{{.author.login}}{{"\t"}}{{.headRefName}}{{"\n"}}{{end}}')

while IFS=$'\t' read -r num _; do
    [[ -n $num ]] && preview_pr "$num" >/dev/null &
done <<<"$prs"

selected=$(printf '%s\n' "$prs" | fzf "${SKIM_THEME_SESSION[@]}" \
    --delimiter='\t' \
    --with-nth=1,2,3 \
    --border-label=' review pr ' \
    --border-label-pos=18 \
    --preview "$SCRIPT_PATH --preview-pr {1}" \
    --preview-window right:60%,border-left)

[[ -z $selected ]] && exit 0

pr_number=$(cut -f1 <<<"$selected")

worktree_dir="${repo_root}/.pr-review/${pr_number}"
local_branch="pr-review-${pr_number}"

session_name="pr-$(basename "$repo_root")-${pr_number}"

if tmux has-session -t "$session_name" 2>/dev/null; then
    if [[ -n ${TMUX:-} ]]; then
        tmux switch-client -t "$session_name"
    else
        tmux attach-session -t "$session_name"
    fi
    exit 0
fi

# No live session for this PR: safe to (re)sync the worktree to the PR's current head,
# picking up any commits pushed since the last time it was reviewed.
git -C "$repo_root" fetch origin "pull/${pr_number}/head"

if [[ ! -d $worktree_dir ]]; then
    mkdir -p "$(dirname "$worktree_dir")"
    git -C "$repo_root" worktree prune
    git -C "$repo_root" worktree add "$worktree_dir" -b "$local_branch" FETCH_HEAD
else
    git -C "$worktree_dir" reset --hard FETCH_HEAD
fi

base_ref=$(gh pr view "$pr_number" --json baseRefName -q .baseRefName)
git -C "$repo_root" fetch origin "$base_ref"
merge_base=$(git -C "$repo_root" merge-base "$local_branch" "origin/$base_ref")

qf_file=$(mktemp)

gh pr diff "$pr_number" --name-only | while IFS= read -r file; do
    printf '%s:1:1:changed in PR #%s\n' "$worktree_dir/$file" "$pr_number" >>"$qf_file"
done

review_cmd="nvim -c 'set errorformat=%f:%l:%c:%m' -c 'Gitsigns change_base $merge_base true' -c 'cfile $qf_file' -c 'copen'; rm -f '$qf_file'; git -C '$repo_root' worktree remove --force '$worktree_dir'; git -C '$repo_root' branch -D '$local_branch'"

tmux new-session -ds "$session_name" -c "$worktree_dir" "$review_cmd"

if [[ -n ${TMUX:-} ]]; then
    tmux switch-client -t "$session_name"
else
    tmux attach-session -t "$session_name"
fi
