---
title: "Obsidian as primary todo store"
status: done
---

## Context

The storage of todos inside the codebase docs folder works fine for private projects where working alone. At work, the acceptance of working with AI agents is not as highly adapted. Having a `/docs/agent-todos` folder in the codebase is not accepted.

An optional workflow is needed where Obsidian becomes the store (not only an import source) for the todos. The agent-todos folder would remain in Obsidian with subfolders reflecting the project, and inside those folders the category folders would be used.

## Tasks

- [x] Plan before implementing anything
- [x] Find out which skills and scripts would need to be modified
- [x] Decide: full Obsidian-primary mode vs. configurable store path → Option A (configurable)
- [x] Add configuration mechanism (plugin settings)
- [x] Parameterize `create-todo.sh`, `update-overview.sh`, `move-todos.sh`
- [x] Replace `todo-overview` with Obsidian Kanban board when store is Obsidian
- [x] Update all SKILL.md documentation
- [x] Add `todo-migrate-to-obsidian` skill (moves docs/agent-todos → Obsidian vault)

## Progress, Decisions etc.

### 2026-02-25: Analysis — Skills and Scripts That Must Change

**Problem restatement:**
At work, placing `docs/agent-todos/` inside a codebase is not acceptable. Obsidian (iCloud-synced) should become the primary store, not just an import source.

**Current data flow (as-is):**

```
Obsidian vault/agent-todos/<project>/ → (import) → docs/agent-todos/<user-chosen-category>/
```

Obsidian is currently read-only/source only. All skills write to `docs/agent-todos/`. The source path uses `<project>` as the subfolder (not category); the user chooses the destination category at import time.

**Scripts with hardcoded paths — must be changed:**

| Script               | Hardcoded line | Path                                   |
| -------------------- | -------------- | -------------------------------------- |
| `create-todo.sh`     | Line 26        | `$BASE_DIR/docs/agent-todos/$CATEGORY` |
| `update-overview.sh` | Lines 5–6      | `$PROJECT_ROOT/docs/agent-todos`       |
| `move-todos.sh`      | Line 15        | `$PROJECT_ROOT/docs/agent-todos`       |

**Skills with hardcoded documentation references — need doc updates:**
All 7 SKILL.md files reference `docs/agent-todos/` in descriptions and examples.

**Two design options:**

**Option A — Configurable store path (recommended)**

- Add `agent-todos-root` to plugin settings (`.claude/agent-todos.local.md` frontmatter)
- Scripts read config, fall back to `docs/agent-todos/`
- Obsidian path would be something like `~/Library/Mobile Documents/iCloud~md~obsidian/Documents/<vault>/agent-todos/`
- Both modes co-exist; users choose per-project
- No breaking changes for existing users

**Option B — Obsidian-only mode**

- Replace all `docs/agent-todos/` with Obsidian vault path
- Eliminates the codebase dependency entirely
- Breaking change for all existing users
- Overview file also lives in Obsidian

**Recommendation:** Option A. Use the `plugin-dev:plugin-settings` pattern to add a configurable `todos-root` key. Scripts read this at runtime. When Obsidian is the primary store, all skills write directly to the vault path — no export mode needed. A dedicated `todo-migrate-to-obsidian` skill handles the one-time move of existing `docs/agent-todos/` content to the Obsidian vault for users switching stores.

**Decisions:**

- **Overview format:** `TODO_OVERVIEW.md` is not useful inside Obsidian. When the store is Obsidian, use an Obsidian Kanban board instead (see `plugins/obsidian/skills/obsidian-kanban`).
- **GitHub issue close comment:** Still reference the file path — it will just point to the Obsidian vault path instead of `docs/agent-todos/`.
- **Sync:** No bidirectional sync needed. Todos live in Obsidian only when Obsidian-primary mode is active.

### 2026-02-25: Implementation Complete

**What was done:**

- Created `.claude/agent-todos.local.md` config pattern with `todos_root`, `vault_root`, `kanban_file` fields
- Added `read_agent_todos_config()` + `_read_fm_key()` helper inline to all 3 scripts (self-contained, no shared script):
  - `create-todo.sh`: replaced hardcoded `$BASE_DIR/docs/agent-todos/$CATEGORY` with `$TODOS_ROOT/$CATEGORY`
  - `move-todos.sh`: replaced hardcoded `TODOS_ROOT` assignment with config reader
  - `update-overview.sh`: added config reader + Obsidian Kanban generation branch
- `update-overview.sh` now:
  - In default mode: generates `TODO_OVERVIEW.md` with Mermaid Kanban + markdown table (unchanged behavior)
  - In Obsidian mode (when `KANBAN_FILE` is set): generates Obsidian Kanban board file at `kanban_file` path with wiki links relative to `vault_root`
- Added `todo-migrate-to-obsidian` skill:
  - `SKILL.md`: 5-step workflow (gather input → run script → write config → run /todo-overview → ask about deletion)
  - `scripts/migrate-to-obsidian.sh`: copies `docs/agent-todos/` to vault, prints config values to stdout
- Updated all 7 SKILL.md files to reference "configured todos directory (default: `docs/agent-todos/`)"
- Bumped `agent-todos` version `0.2.5` → `0.3.0` in `plugin.json` and `marketplace.json`

**Architecture:**

Config is read at script runtime via awk frontmatter parsing. `~` in paths is expanded to `$HOME`. Fallback to `docs/agent-todos/` when no config file exists — zero breaking changes for existing users.
