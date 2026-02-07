---
title: "improve import skill"
status: done
---

# improve import skill

- [x] Use the /skill-development skill to perform this task
- [x] rename the `/todo-importing` skill into `/todo-gh-issue-import`
- [x] the import skill needs `gh` (https://cli.github.com/) this has to be told to the user if not installed (is there a standard in anthropic skills to tell dependencies? see https://agentskills.io/specification()
- [x] the import skill should use the /todo-creation skill for creatin a todo before inserting the content form github issue
- [x] the status should be `ready` for todos imported by that skill.

## Progress, Decisions etc.

### 2026-02-07: Completed all improvements

**What was done:**

- Renamed skill directory from `todo-importing` to `todo-gh-issue-import`
- Updated all references across the codebase (CLAUDE.md, todo-init SKILL.md, todo-init resources/README.md, docs/agent-todos/README.md)
- Added `compatibility: Requires gh CLI (https://cli.github.com/)` field to frontmatter per the Agent Skills spec
- Added a Prerequisites section that checks for `gh` installation and shows an install message if missing
- Rewrote workflow to use `/todo-creation` skill (via Skill tool) for file creation before populating with issue content
- Explicitly documented that imported todos get `status: ready` (created as `new` by /todo-creation, then updated to `ready` after content is added)
- Improved the description field for better skill triggering
- Added `argument-hint: "[category]"` for optional category override

**Decisions made:**

- Used the Agent Skills `compatibility` field (not a custom field) to declare the `gh` dependency, since the spec supports this
- Did not modify historical DONE_ files — those are immutable records
- Added `Edit` and `AskUserQuestion` to allowed-tools since the skill now needs to edit files created by /todo-creation and may ask the user for category selection
