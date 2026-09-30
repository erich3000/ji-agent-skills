#!/usr/bin/env bash
# Install skills from ji-agent-skills into the visible agent-skills/ folder.
#
# Usage:
#   bash install-skills.sh                          # install all plugins into ./agent-skills
#   bash install-skills.sh cmux-tools git-skills    # install specific plugins only
#   bash install-skills.sh --target .claude/skills  # install to a specific legacy directory
#   bash install-skills.sh cmux-tools --target ~/.codex/skills
#
# Remote usage (no clone needed):
#   curl -sSL https://raw.githubusercontent.com/erich3000/ji-agent-skills/main/install-skills.sh | bash
#   curl -sSL https://raw.githubusercontent.com/erich3000/ji-agent-skills/main/install-skills.sh | bash -s -- cmux-tools git-skills

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXPLICIT_TARGET=""
PLUGINS=()

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      EXPLICIT_TARGET="$2"
      shift 2
      ;;
    --target=*)
      EXPLICIT_TARGET="${1#--target=}"
      shift
      ;;
    -*)
      echo "Unknown option: $1" >&2
      exit 1
      ;;
    *)
      PLUGINS+=("$1")
      shift
      ;;
  esac
done

# When invoked via curl | bash, BASH_SOURCE[0] is not a real path — detect and fetch repo
if [[ "$REPO_ROOT" == *"/dev/fd"* ]] || [[ ! -d "$REPO_ROOT/plugins" ]]; then
  TMPDIR_CLONE=$(mktemp -d)
  trap 'rm -rf "$TMPDIR_CLONE"' EXIT
  echo "Cloning ji-agent-skills..."
  git clone --depth 1 --quiet https://github.com/erich3000/ji-agent-skills.git "$TMPDIR_CLONE"
  REPO_ROOT="$TMPDIR_CLONE"
fi

# Default to all plugins if none specified
if [[ ${#PLUGINS[@]} -eq 0 ]]; then
  while IFS= read -r dir; do
    PLUGINS+=("$(basename "$dir")")
  done < <(find "$REPO_ROOT/plugins" -mindepth 1 -maxdepth 1 -type d | sort)
fi

# Determine target directory
CWD="$(pwd)"
TARGETS=()

if [[ -n "$EXPLICIT_TARGET" ]]; then
  if [[ "$EXPLICIT_TARGET" == /* ]]; then
    TARGETS+=("$EXPLICIT_TARGET")
  else
    TARGETS+=("$CWD/$EXPLICIT_TARGET")
  fi
  echo "Installing to explicit target:"
  echo "  $EXPLICIT_TARGET"
  echo ""
else
  TARGETS+=("$CWD/agent-skills")
  echo "Installing to canonical project skills folder:"
  echo "  agent-skills/"
  echo "Run agent-skills-share afterwards to link local agents to it."
  echo ""
fi

# Install skills into a single target directory
install_to() {
  local target_abs="$1"
  local installed=()
  local skipped=()

  for plugin in "${PLUGINS[@]}"; do
    plugin_dir="$REPO_ROOT/plugins/$plugin"
    if [[ ! -d "$plugin_dir/skills" ]]; then
      skipped+=("$plugin")
      continue
    fi

    while IFS= read -r skill_dir; do
      skill_name="$(basename "$skill_dir")"
      skill_md="$skill_dir/SKILL.md"
      [[ -f "$skill_md" ]] || continue
      dest_dir="$target_abs/$skill_name"
      mkdir -p "$dest_dir"
      cp "$skill_md" "$dest_dir/SKILL.md"
      for sub in scripts references assets; do
        [[ -d "$skill_dir/$sub" ]] && cp -r "$skill_dir/$sub" "$dest_dir/"
      done
      installed+=("$skill_name")
    done < <(find "$plugin_dir/skills" -mindepth 1 -maxdepth 1 -type d | sort)
  done

  if [[ ${#installed[@]} -gt 0 ]]; then
    echo "Installed ${#installed[@]} skill(s) to $target_abs:"
    for s in "${installed[@]}"; do echo "  + $s"; done
  fi

  if [[ ${#skipped[@]} -gt 0 ]]; then
    echo "Skipped (plugin not found): ${skipped[*]}"
  fi
}

for target in "${TARGETS[@]}"; do
  install_to "$target"
  echo ""
done

echo "Done."
if [[ -z "$EXPLICIT_TARGET" ]]; then
  echo "Next: run agent-skills-share in this project to create local agent symlinks."
fi
