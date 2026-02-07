---
title: Change Todo Prefix To 4 Digits
status: done
---

## Problem / Context

Todo files currently use 3-digit numeric prefixes. Update the workflow to use 4-digit prefixes, add a migration skill for existing projects, and bump the plugin version.

## Tasks

- [x] Update `/todo-processing` and `/todo-importing` to use 4-digit prefixes
- [x] Update documentation references, including the todo-init README
- [x] Add `/todo-migration` skill for existing projects
- [x] Support folder rename from `docs/agents-todos` to `docs/agent-todos`
- [x] Handle 4-digit renaming for existing todo files
- [x] Bump the plugin version with a patch

## Progress, Decisions etc.

### 2026-02-06: Implement 4-Digit Prefix Workflow

**What was done:**

- Updated `todo-processing`, `todo-importing`, and `todo-init` to document 4-digit prefixes.
- Updated docs in `docs/agent-todos/README.md` and the todo-init template README.
- Added the `todo-migration` skill with guidance and commands for renaming legacy folders and 3-digit files.
- Bumped the `agent-todos` plugin version to `0.0.2` in plugin and marketplace metadata.

**Decisions made:**

- Use zero-padding to 4 digits (e.g., `0001_`) for consistency and future growth.
