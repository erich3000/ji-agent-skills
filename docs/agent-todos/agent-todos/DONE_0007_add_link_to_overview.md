---
title: "add link to overview"
status: done
---

## Context

The Readme in `/docs/agent-todos` should contain a link ot the overview.

## Tasks

- enhance the Readme Template in `plugins/agent-todos/skills/todo-init/resources/README.md``
- add a section new section after the Lifecyce section describing the overwiere and adding a link

## Progress, Decisions etc.

### 2026-02-07: Added overview links to todo README docs

**What was done:**

- Added a new `## Overview` section after `## Status Lifecycle` in `plugins/agent-todos/skills/todo-init/resources/README.md`.
- Added the same `## Overview` section in `docs/agent-todos/README.md` so the current docs match the template.
- Updated `plugins/agent-todos/skills/todo-init/SKILL.md` README template block to include both lifecycle and overview sections with the `/docs/agent-todos/TODO_OVERVIEW.md` link.

**Decisions made:**

- Used an absolute docs link (`/docs/agent-todos/TODO_OVERVIEW.md`) for consistency with the updated overview link format.
