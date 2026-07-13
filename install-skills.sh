#!/usr/bin/env bash
# Install skills from ji-agent-skills into any agent's skills directory.
#
# Usage:
#   bash install-skills.sh                          # install all plugins → .codex/skills/
#   bash install-skills.sh cmux-tools git-skills    # install specific plugins
#   bash install-skills.sh --target .claude/skills  # custom target directory
#   bash install-skills.sh cmux-tools --target ~/.codex/skills
#
# Remote usage (no clone needed):
#   curl -sSL https://raw.githubusercontent.com/erich3000/ji-agent-skills/main/install-skills.sh | bash
#   curl -sSL https://raw.githubusercontent.com/erich3000/ji-agent-skills/main/install-skills.sh | bash -s -- cmux-tools git-skills

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET=".codex/skills"
PLUGINS=()

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      TARGET="$2"
      shift 2
      ;;
    --target=*)
      TARGET="${1#--target=}"
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

# Resolve target relative to CWD (not repo root)
TARGET_ABS="$(pwd)/$TARGET"
if [[ "$TARGET" == /* ]]; then
  TARGET_ABS="$TARGET"
fi

INSTALLED=()
SKIPPED=()

for plugin in "${PLUGINS[@]}"; do
  plugin_dir="$REPO_ROOT/plugins/$plugin"
  if [[ ! -d "$plugin_dir/skills" ]]; then
    echo "  [skip] $plugin — no skills directory found"
    SKIPPED+=("$plugin")
    continue
  fi

  while IFS= read -r skill_dir; do
    skill_name="$(basename "$skill_dir")"
    skill_md="$skill_dir/SKILL.md"
    if [[ ! -f "$skill_md" ]]; then
      continue
    fi
    dest_dir="$TARGET_ABS/$skill_name"
    mkdir -p "$dest_dir"
    cp "$skill_md" "$dest_dir/SKILL.md"
    # Copy scripts/ and references/ if present
    for sub in scripts references; do
      if [[ -d "$skill_dir/$sub" ]]; then
        cp -r "$skill_dir/$sub" "$dest_dir/"
      fi
    done
    INSTALLED+=("$skill_name")
  done < <(find "$plugin_dir/skills" -mindepth 1 -maxdepth 1 -type d | sort)
done

echo ""
if [[ ${#INSTALLED[@]} -gt 0 ]]; then
  echo "Installed ${#INSTALLED[@]} skill(s) to $TARGET:"
  for s in "${INSTALLED[@]}"; do
    echo "  + $s"
  done
fi

if [[ ${#SKIPPED[@]} -gt 0 ]]; then
  echo ""
  echo "Skipped (plugin not found):"
  for s in "${SKIPPED[@]}"; do
    echo "  - $s"
  done
fi

echo ""
echo "Done. Skills are ready in: $TARGET"
