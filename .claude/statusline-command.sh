#!/usr/bin/env bash
# Claude Code Status Line - Catppuccin Mocha Theme
# Multi-line dashboard with box-drawing borders

input=$(cat)

# ── Extract JSON values ─────────────────────────────────────────────────
model_name=$(echo "$input" | jq -r '.model.display_name // empty')
model_id=$(echo "$input" | jq -r '.model.id // "unknown"')
version=$(echo "$input" | jq -r '.version // "?"')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // "~"')
project_dir=$(echo "$input" | jq -r '.workspace.project_dir // .cwd // "~"')
context_size=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')
input_tokens=$(echo "$input" | jq -r '.context_window.current_usage.input_tokens // 0')
output_tokens=$(echo "$input" | jq -r '.context_window.current_usage.output_tokens // 0')
cache_read=$(echo "$input" | jq -r '.context_window.current_usage.cache_read_input_tokens // 0')
cache_write=$(echo "$input" | jq -r '.context_window.current_usage.cache_creation_input_tokens // 0')
total_cost=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
duration_ms=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')
lines_added=$(echo "$input" | jq -r '.cost.total_lines_added // 0')
lines_removed=$(echo "$input" | jq -r '.cost.total_lines_removed // 0')
vim_mode=$(echo "$input" | jq -r '.vim.mode // empty')
agent_name=$(echo "$input" | jq -r '.agent.name // empty')

# Rate limits (added Feb 2026)
session_pct=$(echo "$input" | jq -r '.rate_limits.session.used_percentage // empty')
session_resets=$(echo "$input" | jq -r '.rate_limits.session.resets_at // empty')
weekly_pct=$(echo "$input" | jq -r '.rate_limits.weekly.used_percentage // empty')
weekly_resets=$(echo "$input" | jq -r '.rate_limits.weekly.resets_at // empty')

# ── Model display name (e.g., "Opus 4.6") ──────────────────────────────
model_ver=$(echo "$model_id" | sed -nE 's/^claude-[a-z]+-([0-9]+)-([0-9]+).*/\1.\2/p')
if [[ -n "$model_name" && -n "$model_ver" && "$model_name" != *"$model_ver"* ]]; then
    model="${model_name} ${model_ver}"
elif [[ -n "$model_name" ]]; then
    model="$model_name"
else
    model="$model_id"
fi

# ── Catppuccin Mocha Colors ────────────────────────────────────────────
PINK=$'\033[38;2;245;194;231m'
GREEN=$'\033[38;2;166;227;161m'
BLUE=$'\033[38;2;137;180;250m'
SKY=$'\033[38;2;137;220;235m'
RED=$'\033[38;2;243;139;168m'
MAUVE=$'\033[38;2;203;166;247m'
PEACH=$'\033[38;2;250;179;135m'
YELLOW=$'\033[38;2;249;226;175m'
OVERLAY=$'\033[38;2;108;112;134m'
SURFACE=$'\033[38;2;88;91;112m'
R=$'\033[0m'

# ── Helpers ────────────────────────────────────────────────────────────
fmt_tokens() {
    local n=${1:-0}
    [[ "$n" =~ ^[0-9]+$ ]] || n=0
    if (( n >= 1000000 )); then
        awk "BEGIN {printf \"%.1fM\", $n/1000000}"
    elif (( n >= 1000 )); then
        awk "BEGIN {printf \"%.1fk\", $n/1000}"
    else
        echo "$n"
    fi
}

fmt_duration() {
    local s=$(( ${1:-0} / 1000 ))
    printf "%02d:%02d:%02d" $(( s/3600 )) $(( (s%3600)/60 )) $(( s%60 ))
}

progress_bar() {
    local pct=${1:-0} w=${2:-10}
    local f=$(( (pct * w + 50) / 100 ))
    (( f > w )) && f=$w
    (( f < 0 )) && f=0
    local e=$(( w - f ))
    # Color by fill level
    local c="$GREEN"
    (( pct >= 50 )) && c="$YELLOW"
    (( pct >= 75 )) && c="$PEACH"
    (( pct >= 90 )) && c="$RED"
    local bar="${c}"
    for ((i=0; i<f; i++)); do bar+="█"; done
    bar+="${SURFACE}"
    for ((i=0; i<e; i++)); do bar+="░"; done
    bar+="${R}"
    echo "$bar"
}

fmt_resets() {
    local ts="$1"
    [[ -z "$ts" || "$ts" == "null" ]] && echo "—" && return
    local now=$(date +%s)
    local then=$(date -d "$ts" +%s 2>/dev/null)
    [[ -z "$then" ]] && echo "—" && return
    local diff=$(( then - now ))
    (( diff <= 0 )) && echo "now" && return
    local h=$(( diff / 3600 )) m=$(( (diff % 3600) / 60 ))
    if (( h > 0 )); then echo "${h}h ${m}m"
    else echo "${m}m"
    fi
}

vlen() {
    local s
    s=$(printf "%s" "$1" | sed 's/\x1b\[[0-9;]*m//g')
    echo "${#s}"
}

bline() {
    local content="$1" w="$2"
    local vl=$(vlen "$content")
    local pad=$(( w - vl ))
    (( pad < 0 )) && pad=0
    printf "%s│%s %s%*s %s│%s\n" "$OVERLAY" "$R" "$content" "$pad" "" "$OVERLAY" "$R"
}

hborder() {
    local w="$1" lc="$2" rc="$3"
    local line=""
    for ((i=0; i<w+2; i++)); do line+="─"; done
    printf "%s%s%s%s%s\n" "$OVERLAY" "$lc" "$line" "$rc" "$R"
}

# Right-align: "left <gap> right" filling width W
ralign() {
    local left="$1" right="$2" w="$3"
    local lv=$(vlen "$left") rv=$(vlen "$right")
    local gap=$(( w - lv - rv ))
    (( gap < 1 )) && gap=1
    printf "%s%*s%s" "$left" "$gap" "" "$right"
}

# Colored value padded to min visible width
pad_val() {
    local val="$1" color="$2" min_w="$3"
    local pad=$(( min_w - ${#val} ))
    (( pad < 0 )) && pad=0
    printf "%s%s%s%*s" "$color" "$val" "$R" "$pad" ""
}

# ── Computed Values ──────────────────────────────────────────────────────
project=$(basename "$project_dir")
path=$(echo "$cwd" | sed "s|^$HOME|~|")

# Context
ctx_used=$(( input_tokens + cache_read + cache_write ))
if (( context_size > 0 )); then
    used_pct=$(awk "BEGIN {printf \"%.1f\", ($ctx_used * 100.0) / $context_size}")
else
    used_pct="0.0"
fi
pct_int=$(printf "%.0f" "$used_pct")
ctx_display=$(fmt_tokens "$ctx_used")
ctx_max=$(fmt_tokens "$context_size")
ctx_bar=$(progress_bar "$pct_int" 10)

in_display=$(fmt_tokens "$input_tokens")
out_display=$(fmt_tokens "$output_tokens")
total_cache=$((cache_read + cache_write))
cache_display=$(fmt_tokens "$total_cache")
if (( cache_read + input_tokens > 0 )); then
    hit_pct=$(awk "BEGIN {printf \"%.0f\", ($cache_read * 100.0) / ($cache_read + $input_tokens)}")
else
    hit_pct="0"
fi
elapsed=$(fmt_duration "$duration_ms")
cost_display=$(printf "%.2f" "$total_cost")

# Git
branch="" dirty=""
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
    export GIT_OPTIONAL_LOCKS=0
    branch=$(git -C "$cwd" branch --show-current 2>/dev/null || echo "detached")
    git -C "$cwd" diff-index --quiet HEAD -- 2>/dev/null || dirty=" ●"
fi

# ── Box Width ──────────────────────────────────────────────────────────
cols=$(tput cols 2>/dev/null || echo 80)
(( cols < 60 )) && cols=80
W=$((cols - 4))

# ── Build Top Box Lines ──────────────────────────────────────────────────

# Build right-column content, pad values so labels start at the same column
t1_right="${PINK}CONTEXT${R} ${GREEN}${ctx_display} / ${ctx_max} (${used_pct}%)${R} ${ctx_bar}"
t2_right="${PINK}ELAPSED${R} ${GREEN}${elapsed}${R}"
rw1=$(vlen "$t1_right") rw2=$(vlen "$t2_right")
rw=$(( rw1 > rw2 ? rw1 : rw2 ))
# Append spaces after shorter entries so all are same width (labels align left)
pad1=$(( rw - rw1 )); (( pad1 < 0 )) && pad1=0
pad2=$(( rw - rw2 )); (( pad2 < 0 )) && pad2=0
t1_right="${t1_right}$(printf '%*s' "$pad1" '')"
t2_right="${t2_right}$(printf '%*s' "$pad2" '')"

# Row 1: MODEL (left) | CONTEXT + bar (right)
t1_left="${PINK}MODEL${R}   ${GREEN}${model}${R}"
t1=$(ralign "$t1_left" "$t1_right" "$W")

# Row 2: PROJECT (left) | ELAPSED (right)
t2_left="${PINK}PROJECT${R} ${GREEN}${project}${R}"
t2=$(ralign "$t2_left" "$t2_right" "$W")

# Row 3: BRANCH (left) | AGENT (right, when active)
if [[ -n "$branch" ]]; then
    t3_left="${PINK}BRANCH${R}  ${GREEN}${branch}${dirty}${R}"
else
    t3_left="${PINK}BRANCH${R}  ${SURFACE}—${R}"
fi
if [[ -n "$agent_name" ]]; then
    t3_right="${PINK}AGENT${R}   ${MAUVE}${agent_name}${R}"
    t3=$(ralign "$t3_left" "$t3_right" "$W")
else
    t3="$t3_left"
fi

# Row 4: PATH
t4="${PINK}PATH${R}    ${BLUE}${path}${R}"

# Row 5: VERSION
t5="${PINK}VERSION${R} ${GREEN}${version}${R}"

# ── Build Bottom Box Lines ───────────────────────────────────────────────

# Build bottom right-column content, pad to equal width so labels align
b1_right="${PINK}SESSION${R} ${PEACH}\$${cost_display}${R}"
brw="$(vlen "$b1_right")"
# RESETS values may vary; compute their widths if present
if [[ -n "$session_pct" ]]; then
    s_resets=$(fmt_resets "$session_resets")
    b_block_right="${PINK}RESETS${R}  ${GREEN}${s_resets}${R}"
    bw=$(vlen "$b_block_right"); (( bw > brw )) && brw=$bw
fi
if [[ -n "$weekly_pct" ]]; then
    w_resets=$(fmt_resets "$weekly_resets")
    b_week_right="${PINK}RESETS${R}  ${GREEN}${w_resets}${R}"
    bw=$(vlen "$b_week_right"); (( bw > brw )) && brw=$bw
fi
# Append spaces after shorter entries so labels start at same column
bpad1=$(( brw - $(vlen "$b1_right") )); (( bpad1 < 0 )) && bpad1=0
b1_right="${b1_right}$(printf '%*s' "$bpad1" '')"
if [[ -n "$b_block_right" ]]; then
    bpad=$(( brw - $(vlen "$b_block_right") )); (( bpad < 0 )) && bpad=0
    b_block_right="${b_block_right}$(printf '%*s' "$bpad" '')"
fi
if [[ -n "$b_week_right" ]]; then
    bpad=$(( brw - $(vlen "$b_week_right") )); (( bpad < 0 )) && bpad=0
    b_week_right="${b_week_right}$(printf '%*s' "$bpad" '')"
fi

# Row 1: IN, OUT, CACHE + hit% (left) | SESSION cost (right)
b1_left="${PINK}IN${R}      $(pad_val "$in_display" "$GREEN" 9)"
b1_left+="${PINK}OUT${R}    $(pad_val "$out_display" "$GREEN" 9)"
b1_left+="${PINK}CACHE${R}   ${GREEN}${cache_display} (${hit_pct}%)${R}"
b1=$(ralign "$b1_left" "$b1_right" "$W")

# Row 2: BLOCK (session rate limit)
b_block=""
if [[ -n "$session_pct" ]]; then
    s_pct_int=$(printf "%.0f" "$session_pct")
    s_bar=$(progress_bar "$s_pct_int" 10)
    b_block_left="${PINK}BLOCK${R}   ${s_bar} ${GREEN}${session_pct}%${R}"
    b_block=$(ralign "$b_block_left" "$b_block_right" "$W")
fi

# Row 3: WEEK (weekly rate limit)
b_week=""
if [[ -n "$weekly_pct" ]]; then
    w_pct_int=$(printf "%.0f" "$weekly_pct")
    w_bar=$(progress_bar "$w_pct_int" 10)
    b_week_left="${PINK}WEEK${R}    ${w_bar} ${GREEN}${weekly_pct}%${R}"
    b_week=$(ralign "$b_week_left" "$b_week_right" "$W")
fi

# Row 4: ADDED/REMOVED and vim mode (optional)
b2=""
if (( lines_added > 0 || lines_removed > 0 )); then
    b2_left="${PINK}ADDED${R}   $(pad_val "+${lines_added}" "$SKY" 9)${PINK}REMOVED${R} ${RED}-${lines_removed}${R}"
    vim_part=""
    if [[ -n "$vim_mode" ]]; then
        case "$vim_mode" in
            NORMAL) vim_part="${BLUE}[N]${R}" ;;
            INSERT) vim_part="${RED}[I]${R}" ;;
            VISUAL) vim_part="${MAUVE}[V]${R}" ;;
        esac
    fi
    if [[ -n "$vim_part" ]]; then
        b2=$(ralign "$b2_left" "$vim_part" "$W")
    else
        b2="$b2_left"
    fi
elif [[ -n "$vim_mode" ]]; then
    case "$vim_mode" in
        NORMAL) b2="${BLUE}[N]${R}" ;;
        INSERT) b2="${RED}[I]${R}" ;;
        VISUAL) b2="${MAUVE}[V]${R}" ;;
    esac
fi

# ── Output ─────────────────────────────────────────────────────────────

# Top box
hborder "$W" "┌" "┐"
bline "$t1" "$W"
bline "$t2" "$W"
bline "$t3" "$W"
bline "$t4" "$W"
bline "$t5" "$W"
hborder "$W" "└" "┘"

echo ""

# Bottom box
hborder "$W" "┌" "┐"
bline "$b1" "$W"
[[ -n "$b_block" ]] && bline "$b_block" "$W"
[[ -n "$b_week" ]] && bline "$b_week" "$W"
[[ -n "$b2" ]] && bline "$b2" "$W"
hborder "$W" "└" "┘"
