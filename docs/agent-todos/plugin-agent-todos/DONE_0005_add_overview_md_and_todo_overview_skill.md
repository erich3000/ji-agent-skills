---
title: "Add TODO_OVERVIEW.md and /todo-overview skill"
status: done
---

## Problem / Context

Use the `/skill-development` skill to implement this work. We want a `TODO_OVERVIEW.md` file in `docs/agent-todos/` that gives the user an overview over all todos as a markdown table with `category`, `todo`, and `status`. We also want a `/todo-overview` skill that creates and updates `TODO_OVERVIEW.md`, and this skill should be triggered by any other skill that adds todos or changes todo status.

## Tasks

- [x] Use `/skill-development` to implement the requested changes
- [x] Add `docs/agent-todos/TODO_OVERVIEW.md` with a markdown table of `category`, `todo`, and `status`
- [x] Create a `/todo-overview` skill that creates and updates `TODO_OVERVIEW.md`
- [x] Ensure the `/todo-overview` skill is triggered by skills that add todos or change todo statuses

## Progress, Decisions etc.

### 2026-02-07: Added overview workflow and integrated with todo skills

**What was done:**

- Added new skill `plugins/agent-todos/skills/todo-overview/SKILL.md`
- Added generator script `plugins/agent-todos/skills/todo-overview/scripts/update-overview.sh`
- Generated `docs/agent-todos/TODO_OVERVIEW.md` with table columns `category`, `todo`, and `status`
- Updated `todo-creation`, `todo-gh-issue-import`, and `todo-processing` skill workflows to trigger `/todo-overview` after todo creation or status changes
- Updated docs in `docs/agent-todos/README.md` and `plugins/agent-todos/skills/todo-init/resources/README.md`
- Updated `plugins/agent-todos/skills/todo-init/SKILL.md` to mention `/todo-overview`
- Bumped `agent-todos` plugin version from `0.1.1` to `0.1.2` in plugin and marketplace metadata

**Decisions made:**

- Implemented overview generation as a Bash script to keep formatting deterministic and reusable across skills
- Kept overview rows sourced from all category subdirectories and both open and done todos
