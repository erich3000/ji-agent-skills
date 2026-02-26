---
title: "enhance-todo-processing"
status: done
---

## Context

We want to enhance the `todo-processing` skill and script

## Tasks

- The skill should behave like that:
  - if the user doe not give todo to process, present a list of all open todos to him (idealy he can choose interactivly)
  - if this list has more then 5 open todo let the user first choose a category (idealy he can choose interactivly)
  - if there are no open todos at all ask the user if he want's to create a new todo instead with the help of the `todo-creation` skill
  - it the the user gives or selects a todo that has no numeric prefix add the next availabe prefix before the todo is processed
  - if the given or selected tofo hat no or missing frontmatter data add it (use filename as title)
- [x] The skill should behave like that:
  - [x] if the user doe not give todo to process, present a list of all open todos to him (idealy he can choose interactivly)
  - [x] if this list has more then 5 open todo let the user first choose a category (idealy he can choose interactivly)
  - [x] if there are no open todos at all ask the user if he want's to create a new todo instead with the help of the `todo-creation` skill
  - [x] it the the user gives or selects a todo that has no numeric prefix add the next availabe prefix before the todo is processed
  - [x] if the given or selected tofo hat no or missing frontmatter data add it (use filename as title)
- [x] After the skill has been improved bump the version of the plugin

## Progress, Decisions etc.

### 2026-02-26: Implemented interactive workflow and normalization

**What was done:**

- Changed `invocation: none` → `invocation: user`; added `allowed-tools`, `argument-hint`
- Rewrote `description` in third-person trigger-phrase format matching sibling skills
- Added `## Invocation` section with three-step workflow: identify todo (interactive if no arg), normalize (prefix + frontmatter), process
- Fixed "Finding Tasks" section to use `<todos-dir>` placeholder instead of hardcoded `docs/agent-todos`
- Made Step 3 handoff explicit: references `## Workflow` by name
- Bumped plugin version `0.5.2` → `0.6.0` in `plugin.json` and `marketplace.json`

**Decisions made:**

- Category filter triggers at >5 todos (matches the task spec)
- `Skill` tool used for `todo-creation` fallback (not a slash command)
- `TODO-[DESCRIPTION].md` alternative format left documented as-is (reviewer noted it; normalization will apply a numeric prefix to it like any other unprefixed file)
