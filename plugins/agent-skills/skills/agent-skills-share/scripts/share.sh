#!/usr/bin/env bash
# Point the agents' skill directories at the project's visible agent-skills/ folder.
#
# Usage: share.sh [--check] [project_root]
#
#   --check        Report the state of each link, change nothing.
#   project_root   Directory that contains agent-skills/ (default: current directory).
#
# Creates relative symlinks:
#   .claude/skills -> ../agent-skills   (Claude Code)
#   .agents/skills -> ../agent-skills   (Codex)
#
# Never copies, moves or deletes skills; only creates the symlinks (and .claude/ or .agents/
# if missing). A real directory, a file or any other symlink target (including an absolute
# path to agent-skills/) is reported as a conflict and left alone.
#
# Exit codes: 0 all links correct (or created), 1 usage error or no agent-skills/,
#             2 conflicts found, or links missing in --check mode.

set -euo pipefail

CHECK=0
ROOT=""
for arg in "$@"; do
  case "$arg" in
    --check) CHECK=1 ;;
    -h|--help) sed -n '2,18p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    -*) echo "Unknown option: $arg" >&2; exit 1 ;;
    *) ROOT="$arg" ;;
  esac
done
ROOT="${ROOT:-$PWD}"
cd "$ROOT"

if [[ ! -d agent-skills || -L agent-skills ]]; then
  echo "No agent-skills/ directory in $PWD. Nothing changed." >&2
  echo "Run agent-skills-init first to create it from an existing skills folder." >&2
  exit 1
fi

TARGET="../agent-skills"
LINKS=(".claude/skills" ".agents/skills")
status=0

for link in "${LINKS[@]}"; do
  if [[ -L "$link" ]]; then
    current="$(readlink "$link")"
    if [[ "$current" == "$TARGET" ]]; then
      echo "ok        $link -> $current"
    else
      echo "CONFLICT  $link is a symlink to '$current', expected '$TARGET'"
      status=2
    fi
  elif [[ -e "$link" ]]; then
    echo "CONFLICT  $link is a real $( [[ -d "$link" ]] && echo directory || echo file ), not a symlink"
    echo "          Migrate its skills into agent-skills/ (agent-skills-init), then remove it and rerun."
    status=2
  elif [[ $CHECK -eq 1 ]]; then
    echo "missing   $link"
    status=2
  else
    mkdir -p "$(dirname "$link")"
    ln -s "$TARGET" "$link"
    echo "created   $link -> $TARGET"
  fi
done

exit $status
