---
title: Add Skill `/todo-creation`
status: done
---

## Task

- [x] Use the /skill-development skill to perform this task
- [x] Create a new skill called /todo-creation
- [x] Skill asks the user for a category and a title
- [x] Skill creates a new to-do Markdown file
- [x] New file is created in a directory that bears the name of the category
- [x] If the directory does not yet exist, it is created
- [x] File has a sequential number (four digits) followed by the title in snake case
- [x] When calculating the numerical prefix, files with status "done" are also taken into account
- [x] If the title is longer than 60 characters, the file name is truncated
- [x] A frontmatter section is created with two fields: title and status (initially new)
- [x] After the header, the title is repeated as an H1 heading
- [x] Below is a prompt for the user to enter or copy in a description
- [x] The user should then set the status to ready
- [x] Implement as a bash script

## Progress, Decisions etc.

### 2026-02-06: Created /todo-creation skill

**What was done:**

- Created `plugins/agent-todos/skills/todo-creation/SKILL.md` with workflow for gathering input, creating the file, and prompting for description
- Created `plugins/agent-todos/skills/todo-creation/scripts/create-todo.sh` implementing all logic:
  - Scans all files (including `DONE_`) in the category for the highest numeric prefix
  - Generates next 4-digit sequential number
  - Converts title to snake_case, truncated to 60 characters
  - Creates file with YAML frontmatter (`title`, `status: new`) and H1 heading
  - Handles YAML-special characters (colons, quotes) via single-quoted scalars
- Updated `docs/agent-todos/README.md` to list the new skill
- Updated `plugins/agent-todos/skills/todo-init/SKILL.md` and its `resources/README.md` to reference the new skill
- Updated `CLAUDE.md` to document the new skill and fix the naming prefix from `[NNN]` to `[NNNN]`
- Bumped plugin version from `0.0.4` to `0.0.5` in both `plugin.json` and `marketplace.json`
- Ran skill-reviewer — addressed all findings (YAML injection fix, expanded trigger phrases, error handling note, wording fix)

**Decisions made:**

- Implemented as a bash script (`create-todo.sh`) rather than inline SKILL.md instructions — deterministic, token-efficient, and avoids re-implementing numbering logic each time
- Used YAML single-quoted scalars for the title to prevent injection from colons, quotes, and other special characters
- Did not create a separate template file in `assets/` — the script generates the file directly, which is simpler and avoids an extra resource to maintain

**Files created:**

- `plugins/agent-todos/skills/todo-creation/SKILL.md`
- `plugins/agent-todos/skills/todo-creation/scripts/create-todo.sh`

**Files modified:**

- `plugins/agent-todos/.claude-plugin/plugin.json` (version bump)
- `.claude-plugin/marketplace.json` (version bump)
- `docs/agent-todos/README.md` (added skill reference)
- `plugins/agent-todos/skills/todo-init/SKILL.md` (added skill reference)
- `plugins/agent-todos/skills/todo-init/resources/README.md` (added skill reference)
- `CLAUDE.md` (added skill documentation)
