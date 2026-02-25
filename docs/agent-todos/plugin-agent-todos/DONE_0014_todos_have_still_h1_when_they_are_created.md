---
title: 'Todos have still h1 when they are created'
status: done
---

## context

the created todos still have a h1 headline reapeating the frontmatter title, wich is non-valid markdown

## task

- [x] check creation and import skills and their scripts to find the place where the h1 headline (# headline) is added to the new todo
- [x] remove the adding of the h1 headline in all places it occurs.
- [x] test ist with the creation skill
- [x] ask the user to provide testing input for both import skills/scripts
- [x] bump the version of the agent-todos plugin

## Progress, Decisions etc.

### 2026-02-25: Started implementation

**What was done:**

- Reviewed the imported todo and switched status from `ready` to `doing`.
- Searched `agent-todos` skills/scripts for places that still mention or imply adding an H1 title line.
- Identified updates needed in creation/import skill docs and creation script comments.

### 2026-02-25: Removed H1 guidance and bumped plugin patch

**What was done:**

- Updated creation/import-related documentation to stop prescribing a repeated H1 title after frontmatter:
  - `plugins/agent-todos/skills/todo-creation/SKILL.md`
  - `plugins/agent-todos/skills/todo-gh-issue-import/SKILL.md`
  - `plugins/agent-todos/skills/todo-processing/SKILL.md`
- Updated creation script comments to match current behavior (no H1 in generated file):
  - `plugins/agent-todos/skills/todo-creation/scripts/create-todo.sh`
- Bumped `agent-todos` plugin patch version:
  - `plugins/agent-todos/.claude-plugin/plugin.json` (`0.2.4` -> `0.2.5`)
  - `.claude-plugin/marketplace.json` (`agent-todos` `0.2.4` -> `0.2.5`)
- Ran creation-skill test in `/tmp`: generated file includes frontmatter + `## Context`/`## Tasks` only (no `# Title` H1).
- Ran import-path sanity checks:
  - `gh --version` succeeded
  - Obsidian import script `--check-platform` and `--list-categories vault-of-jens` succeeded.

**Decisions made:**

- Treated stale skill instructions/examples as the primary source of H1 re-introduction risk and removed those examples.
- Kept runtime import scripts unchanged where they did not inject H1 directly.

**Outstanding questions:**

1. Please provide a test input for GitHub import:
   - category to import into (or confirm label-based mapping),
   - whether I should import all open issues or a limited subset.
2. Please provide a test input for Obsidian import:
   - vault name,
   - source category,
   - destination category.

### 2026-02-25: Completed implementation and requested import test inputs

**What was done:**

- Completed code and documentation changes to prevent repeated H1 title lines in todo outputs.
- Marked task items complete and prepared follow-up validation request inputs for both import workflows.
