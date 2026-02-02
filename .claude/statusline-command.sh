#!/usr/bin/env bash

# Read JSON input from stdin
input=$(cat)

# Extract values from JSON
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
model=$(echo "$input" | jq -r '.model.display_name // .model.id')
vim_mode=$(echo "$input" | jq -r '.vim.mode // empty')
agent_name=$(echo "$input" | jq -r '.agent.name // empty')

# Extract context window size
context_size=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')

# Extract cache stats
cache_read=$(echo "$input" | jq -r '.context_window.current_usage.cache_read_input_tokens // 0')
cache_write=$(echo "$input" | jq -r '.context_window.current_usage.cache_creation_input_tokens // 0')

# Extract productivity metrics
lines_added=$(echo "$input" | jq -r '.cost.total_lines_added // 0')
lines_removed=$(echo "$input" | jq -r '.cost.total_lines_removed // 0')

# Color palette (Catppuccin-inspired, matching oh-my-posh config)
OS_COLOR=$'\033[38;2;172;176;190m'      # os/closer color
PINK=$'\033[38;2;245;194;231m'          # path color
BLUE=$'\033[38;2;137;180;250m'          # git color
SKY=$'\033[38;2;137;220;235m'           # changes/ahead color
RED=$'\033[38;2;243;139;168m'           # error/behind color
MAUVE=$'\033[38;2;203;166;247m'         # visual mode color
RESET=$'\033[0m'

# Build output
output=""

# Model name
output+="${OS_COLOR}Model:${RESET} ${PINK}${model}${RESET}"

# Agent (if active)
if [[ -n "$agent_name" ]]; then
    output+=" ${OS_COLOR}|${RESET} ${OS_COLOR}Agent:${RESET} ${MAUVE}${agent_name}${RESET}"
fi

# Path (shortened)
short_path=$(echo "$cwd" | sed "s|^$HOME|~|" | awk -F'/' '{
    if (NF <= 2) print $0;
    else printf "..%s/%s", $(NF-1), $NF
}')
output+=" ${OS_COLOR}|${RESET} ${BLUE}${short_path}${RESET}"

# Git status (if in git repo)
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    # Skip optional locks for git commands
    export GIT_OPTIONAL_LOCKS=0

    branch=$(git -C "$cwd" branch --show-current 2>/dev/null || echo "detached")

    # Check for changes
    if ! git -C "$cwd" diff-index --quiet HEAD -- 2>/dev/null; then
        changes=" ●"
    else
        changes=""
    fi

    output+=" ${SKY}(${branch}${changes})${RESET}"
fi

# Token usage - calculate from actual usage fields (excludes autocompact buffer)
input_tokens=$(echo "$input" | jq -r '.context_window.current_usage.input_tokens // 0')
output_tokens=$(echo "$input" | jq -r '.context_window.current_usage.output_tokens // 0')

# Sum actual tokens used (input + output, cache tokens are part of input)
context_tokens=$((input_tokens + output_tokens))

# Calculate percentage based on actual usage
used_percent_int=$(awk "BEGIN {printf \"%.0f\", ($context_tokens * 100) / $context_size}")

# Format numbers with k suffix if > 1000
if [[ $context_tokens -gt 1000 ]]; then
    total_display=$(awk "BEGIN {printf \"%.0fk\", $context_tokens/1000}")
else
    total_display="${context_tokens}"
fi
if [[ $context_size -gt 1000 ]]; then
    context_display=$(awk "BEGIN {printf \"%.0fk\", $context_size/1000}")
else
    context_display="${context_size}"
fi

output+=" ${OS_COLOR}|${RESET} ${OS_COLOR}Tokens:${RESET} ${RED}${total_display}${RESET}${OS_COLOR}/${RESET}${BLUE}${context_display}${RESET} ${OS_COLOR}(${used_percent_int}%)${RESET}"

# Cache stats (if cache is being used)
if [[ $cache_read -gt 0 || $cache_write -gt 0 ]]; then
    total_cache=$((cache_read + cache_write))
    if [[ $total_cache -gt 0 ]]; then
        cache_hit_percent=$(awk "BEGIN {printf \"%.0f\", ($cache_read * 100) / $total_cache}")
    else
        cache_hit_percent=0
    fi

    # Format cache size
    if [[ $cache_read -gt 1000 ]]; then
        cache_display=$(awk "BEGIN {printf \"%.0fk\", $cache_read/1000}")
    else
        cache_display="${cache_read}"
    fi

    output+=" ${OS_COLOR}|${RESET} ${OS_COLOR}Cache:${RESET} ${BLUE}${cache_display}${RESET} ${OS_COLOR}(${cache_hit_percent}%)${RESET}"
fi

# Lines changed (if any edits have been made)
if [[ $lines_added -gt 0 || $lines_removed -gt 0 ]]; then
    output+=" ${OS_COLOR}|${RESET} ${SKY}+${lines_added}${RESET}${OS_COLOR}/${RESET}${RED}-${lines_removed}${RESET}"
fi

# Vim mode indicator
if [[ -n "$vim_mode" ]]; then
    if [[ "$vim_mode" == "NORMAL" ]]; then
        output+=" ${OS_COLOR}|${RESET} ${BLUE}[N]${RESET}"
    elif [[ "$vim_mode" == "INSERT" ]]; then
        output+=" ${OS_COLOR}|${RESET} ${RED}[I]${RESET}"
    elif [[ "$vim_mode" == "VISUAL" ]]; then
        output+=" ${OS_COLOR}|${RESET} ${MAUVE}[V]${RESET}"
    fi
fi

# Print the status line
printf "%s" "$output"
