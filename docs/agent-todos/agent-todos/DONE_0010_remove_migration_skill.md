---
title: "remove migration skill"
status: done
---

## Context

The skill `plugins/agent-todos/skills/todo-migration` is no longer needed as all repos have been migrated

## Tasks

- delete the skill
- adjust all documentation
- bump the plugin version (minor)

## Progress, Decisions etc.

### 2026-02-07: Removed migration skill and updated docs/version

**What was done:**

- Deleted the migration skill source at `plugins/agent-todos/skills/todo-migration/SKILL.md`.
- Removed the now-empty directory `plugins/agent-todos/skills/todo-migration/`.
- Removed `/todo-migration` references from active documentation files:
  - `docs/agent-todos/README.md`
  - `plugins/agent-todos/skills/todo-init/resources/README.md`
  - `plugins/agent-todos/skills/todo-init/SKILL.md`
- Bumped `agent-todos` plugin version from `0.1.3` to `0.2.0` in:
  - `plugins/agent-todos/.claude-plugin/plugin.json`
  - `.claude-plugin/marketplace.json`

**Decisions made:**

- Kept historical references in completed todo files unchanged, while removing only active skill/docs references.
