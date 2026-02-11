---
title: Agent Todos Obsidian Importer
status: done
---

## Problem / Context

Right now, the Obsidian importer creates todos in a folder (category) with the same name as the source folder in Obsidian. That can lead to folders with the same name as the repository, which is confusing.

Change this so the importer asks for the destination folder for each imported todo. The skill should list the available destination folders.

## Tasks

- [x] Review and refine this imported todo
- [x] Bump the plugin version as patch

## Progress, Decisions etc.

### 2026-02-11: Implemented destination category selection

**What was done:**

- Added new step 4 "Choose Destination Category" to the SKILL.md workflow
- The importer now asks the user to pick a local destination category (from existing `docs/agent-todos/` subdirectories) instead of reusing the Obsidian source category name
- Renamed "todo-category" references to "source-category" for clarity
- Updated the example to show the new flow
- Bumped plugin version from 0.2.2 to 0.2.3

**Files modified:**

- `plugins/agent-todos/skills/todo-obsidian-icloud-import/SKILL.md`
- `plugins/agent-todos/.claude-plugin/plugin.json`
- `.claude-plugin/marketplace.json`
