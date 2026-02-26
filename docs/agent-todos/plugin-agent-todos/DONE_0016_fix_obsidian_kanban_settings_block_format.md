---
title: 'Fix Obsidian Kanban settings block format'
status: done
---

## Context

The `update-overview.sh` script generates the Kanban settings block using a fenced code block:

    %% kanban:settings
    ```json
    {"kanban-plugin":"board"}
    ```
    %%

The Obsidian Kanban plugin cannot parse this — it expects raw JSON directly after `kanban:settings`, not a fenced code block with a `json` language hint. The plugin errors with:

```
SyntaxError: Unexpected token 'j', "json {"kan"... is not valid JSON
```

The valid format is:

    %% kanban:settings
    {"kanban-plugin":"board"}
    %%

## Tasks

- [x] Fix the `generate_obsidian_kanban()` function in `update-overview.sh` to emit the settings block without the fenced code block wrapper

## Progress, Decisions etc.

### 2026-02-25: Removed fenced JSON wrapper from kanban settings block

**What was done:**

- Updated `plugins/agent-todos/skills/todo-overview/scripts/update-overview.sh` in `generate_obsidian_kanban()` to remove the fenced code block markers around the JSON settings payload.
- Kept the settings block as:
  - `%% kanban:settings`
  - `{"kanban-plugin":"board"}`
  - `%%`
- Regenerated an Obsidian-mode board via the script and verified the output uses raw JSON in the settings section.

**Decisions made:**

- Applied a minimal patch to the output template only; no changes to lane generation or link formatting were needed for this fix.
