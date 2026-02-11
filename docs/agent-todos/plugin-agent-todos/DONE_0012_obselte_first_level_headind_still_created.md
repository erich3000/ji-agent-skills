---
title: "Obselte first level headind still created"
status: done
---

## Context

During import the title is still repeated as level 1 heading `# title` in the body which leads to non valid markdown

## Tasks

- [x] Scan both import skill and their scripts
- [x] Remove the creation of the first level heading
- [x] Bump the plugin version as patch

## Progress, Decisions etc.

### 2026-02-11: Removed stale H1 guidance and aligned docs/scripts

**What was done:**

- Updated `todo-creation` skill docs to remove outdated references that said an H1 is created.
- Updated `create-todo.sh` comments to match actual behavior (frontmatter + section stubs, no H1).
- Updated `todo-obsidian-icloud-import` skill to explicitly forbid adding/re-adding `# Title` during import.
- Bumped `agent-todos` plugin version from `0.2.1` to `0.2.2` in plugin manifest and marketplace entry.

**Decisions made:**

- Keep todo bodies section-based (`## ...`) and avoid duplicating the title as an H1 in generated/imported content.
