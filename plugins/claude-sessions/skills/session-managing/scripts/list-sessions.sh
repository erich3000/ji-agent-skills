#!/usr/bin/env bash
# List local Claude Code processes as TSV. This script never changes processes.
set -euo pipefail

format_epoch() {
  local start=$1 epoch
  if epoch=$(date -j -f '%a %b %e %T %Y' "$start" '+%s' 2>/dev/null); then printf '%s' "$epoch"; else date -d "$start" '+%s' 2>/dev/null || printf ''; fi
}

format_date() {
  local epoch=$1
  if date -r "$epoch" '+%Y-%m-%dT%H:%M:%S%z' 2>/dev/null; then :; else date -d "@$epoch" '+%Y-%m-%dT%H:%M:%S%z'; fi
}

format_short_date() {
  local epoch=$1
  if date -r "$epoch" '+%d.%m.' 2>/dev/null; then :; else date -d "@$epoch" '+%d.%m.'; fi
}

own_claude_pids() {
  local pid=$$ parent comm
  while [ "$pid" -gt 1 ] 2>/dev/null; do
    comm=$(ps -p "$pid" -o comm= 2>/dev/null | sed 's/^[[:space:]]*//')
    [ "${comm##*/}" = claude ] && printf '%s\n' "$pid"
    parent=$(ps -p "$pid" -o ppid= 2>/dev/null | tr -d '[:space:]')
    [ -n "$parent" ] && [ "$parent" != "$pid" ] || break
    pid=$parent
  done
}

environment_for() {
  local pid=$1 depth=0 info comm parent
  while [ "$pid" -gt 1 ] 2>/dev/null && [ "$depth" -lt 8 ]; do
    info=$(ps -p "$pid" -o ppid= -o comm= 2>/dev/null) || break
    parent=${info%%[![:space:]]*}; info=${info#"$parent"}; parent=$(printf '%s' "$parent" | tr -d '[:space:]')
    comm=$(printf '%s' "$info" | sed 's/^[[:space:]]*//')
    case "$comm" in
      *cmux*) printf 'cmux'; return ;;
      *Obsidian*) printf 'Obsidian'; return ;;
      *Terminal.app*) printf 'Terminal.app'; return ;;
      *iTerm.app*) printf 'iTerm2'; return ;;
      *Visual\ Studio\ Code*|*Code\ Helper*) printf 'VS Code'; return ;;
      *Claude.app*) printf 'Claude Desktop'; return ;;
    esac
    [ -n "$parent" ] && [ "$parent" != "$pid" ] || break
    pid=$parent; depth=$((depth + 1))
  done
  printf 'unknown'
}

printf 'pid\tstart_iso\tstart_date\tcwd\tenvironment\n'
own_pids=$(own_claude_pids || true)
while IFS= read -r pid; do
  [ -n "$pid" ] || continue
  printf '%s\n' "$own_pids" | grep -qx "$pid" && continue
  start=$(ps -p "$pid" -o lstart= 2>/dev/null | sed 's/^[[:space:]]*//') || continue
  [ -n "$start" ] || continue
  epoch=$(format_epoch "$start"); [ -n "$epoch" ] || continue
  cwd=$(lsof -a -p "$pid" -d cwd -Fn 2>/dev/null | sed -n 's/^n//p' | head -n 1)
  printf '%s\t%s\t%s\t%s\t%s\n' "$pid" "$(format_date "$epoch")" "$(format_short_date "$epoch")" "${cwd:-unknown}" "$(environment_for "$pid")"
done < <(pgrep -x claude 2>/dev/null || true)
