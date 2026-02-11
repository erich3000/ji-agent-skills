---
title: "describe obsidian import in readme"
status: done
---

## Context

we now have the `todo-obsidian-icloud-import` skill, but users do no know what has to be done in obsidian to use it.

## Tasks

- [x] a subsection to `### Agent Todos` explaining each individual skill of this plugin
- [x] add a description of the setup of folders on obsidian to the import skill

## Progress, Decisions etc.

### 2026-02-11: Completed

**What was done:**

- Added `#### Skills` table under `### Agent Todos` in README.md listing all 6 skills with descriptions
- Added `#### Obsidian Import Setup` section with vault directory structure and iCloud Drive path
- Updated CLAUDE.md to include missing `todo-overview` and `todo-obsidian-icloud-import` skills
- Fixed markdown lint warnings (added language specifiers to fenced code blocks)
