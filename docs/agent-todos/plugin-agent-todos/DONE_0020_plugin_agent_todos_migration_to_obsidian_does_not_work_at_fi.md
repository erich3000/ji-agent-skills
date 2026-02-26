---
title: 'Plugin agent-todos: Migration to obsidian does not work at first attempt'
status: done
---

## Problem / Context

Two issues encountered during `/todo-migrate-to-obsidian`:

### 1. Skill ignored existing `.claude/agent-todos.local.json`

The config file was already present with all three required values (`todosRoot`, `vaultRoot`, `kanbanFile`). The skill's workflow did not check for this file before starting vault discovery. Instead it proceeded to list vaults from iCloud Drive, which wasted steps and caused confusion.

**Suggested fix:** At the start of the workflow, check for `.claude/agent-todos.local.json`. If it already contains `vaultRoot` and `todosRoot`, skip vault discovery and jump directly to step 2 (running the migration script).

### 2. Migration script hardcoded to iCloud Drive path

The vault was located at `~/Obsidian/vault-of-jens` (not under `~/Library/Mobile Documents/iCloud~md~obsidian/Documents/`). The `migrate-to-obsidian.sh` script only checks the iCloud path and exited with an error:

```
Error: Vault not found: /Users/.../iCloud~md~obsidian/Documents/vault-of-jens
```

The workaround was to copy files manually using `cp` and then run `/todo-overview` directly.

**Suggested fix:** When `vaultRoot` is already set in `.claude/agent-todos.local.json`, pass the resolved absolute path to the script and skip the iCloud vault lookup. Alternatively, add a `--vault-path` flag to the script that accepts an absolute path directly.

## Tasks

- [x] Check for existing `.claude/agent-todos.local.json` at the start of `todo-migrate-to-obsidian` skill; if `vaultRoot` and `todosRoot` are present, skip vault discovery
- [x] Update `migrate-to-obsidian.sh` to use the configured `vaultRoot` directly instead of hardcoding the iCloud Drive path

## Progress, Decisions etc.

### 2026-02-26: Implemented config-check shortcut and absolute-path vault support

**What was done:**

- `SKILL.md`: Added new Step 1 "Check Existing Config" — reads `.claude/agent-todos.local.json`; if `vaultRoot` + `todosRoot` present, checks whether `docs/agent-todos/` still exists (if not → already migrated, stop); otherwise skips vault discovery and proceeds directly to migration script with `vaultRoot` as vault argument
- `SKILL.md`: Step 2 now documents that absolute-path vault arguments (starting with `/` or `~`) must not be split on spaces; use `AskUserQuestion` for ambiguous cases
- `migrate-to-obsidian.sh`: Added branch to use absolute paths directly as `VAULT_PATH`, bypassing iCloud Drive lookup; `~`-prefixed paths expanded via `${VAULT_NAME/#\~/$HOME}`
- Renamed usage comment parameter label to `vault_name_or_path`
- Updated `compatibility` frontmatter and macOS note to no longer require iCloud Drive specifically

**Decisions made:**

- Tilde expansion limited to `~/...` form only (not `~username/...`) — acceptable for this use case, documented via usage comment
- Re-invocation with existing config + deleted source → fail cleanly with "already completed" message rather than silently re-copying nothing
