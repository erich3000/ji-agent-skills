---
title: Add status to todo
status: done
---

## Task

- [x] Add YAML frontmatter to todo files with two fields: `title` and `status`
- [x] Status values: `new`, `ready`, `doing`, `done`, `archived`
- [x] When a todo is created it gets status `new`
- [x] After the user enters text it gets status `ready`
- [x] The `/todo-processing` skill sets status to `doing`
- [x] When a todo is marked as done it gets status `done`
- [x] The `archived` status is not used for now
- [x] Create a `/todo-migration` skill that scans all existing todo files and adds the frontmatter
- [x] The title is generated from the filename by replacing underscores and hyphens with spaces
- [x] Existing todos with text content get status `ready`
- [x] Existing todos with the `DONE_` prefix get status `done`

## Progress, Decisions etc.

### 2026-02-06: Verified — all items already implemented

**What was done:**

- Reviewed all four skills (`todo-processing`, `todo-importing`, `todo-init`, `todo-migration`) against the task requirements
- Every item was already implemented in prior commits:
  - `todo-processing` SKILL.md documents frontmatter fields (`title`, `status`), the full status lifecycle (`new` → `ready` → `doing` → `done` → `archived`), and the workflow for status transitions
  - `todo-importing` SKILL.md creates files with `status: ready` frontmatter
  - `todo-migration` SKILL.md handles adding frontmatter to legacy files, deriving title from filename, and setting status based on content/`DONE_` prefix
- Ran the migration on this repo's own todo files — all 5 files now have frontmatter
- Marked all task items as complete
