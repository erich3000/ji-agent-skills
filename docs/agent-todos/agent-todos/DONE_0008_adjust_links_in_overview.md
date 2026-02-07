---
title: "adjust links in overview"
status: done
---

## Context

The links in the generated overview start with `docs/...` but that should be `/docs/...` to work in github

## Tasks

- adjust the `todo-overview` skill and scropt to build correct links

## Progress, Decisions etc.

### 2026-02-07: Fixed overview links for GitHub rendering

**What was done:**

- Updated `plugins/agent-todos/skills/todo-overview/scripts/update-overview.sh` so generated table links now start with `/docs/...` instead of `docs/...`.
- Updated `plugins/agent-todos/skills/todo-overview/SKILL.md` notes to document the leading-slash link behavior.
- Regenerated `docs/agent-todos/TODO_OVERVIEW.md` to apply corrected links.

**Decisions made:**

- Kept links root-relative (`/docs/...`) because this matches the requested GitHub behavior.
