---
title: "Visusalisation in Overview"
status: done
---

## Context

- We want to give the user a visual overview over the todos
- the idea is to use mermaid diagramm (https://mermaid.js.org/syntax/kanban.html) to visulalize which todo is in which status

## Tasks

- every Todo should have an id of they type `[CATEGORY]-[4 DIGIT PREFIX]`
- we do not want to show the archived todos
- i think we should use a script to build that stucture

### Exampla Kanban

```mermaid
%%{init: {"theme":"neutral"}}%%
kanban
  new[New]

  ready[Ready]
    agent-todos-0006[Visusalisation in Overview]@{ ticket: agent-todos-0006 }

  doing[Doing]

  done[Done]
    agent-todos-0000[Change Todo Prefix To 4 Digits]@{ ticket: agent-todos-0000 }
    agent-todos-0001[Error when installing Plugin]@{ ticket: agent-todos-0001 }
    agent-todos-0002[Add status to todo]@{ ticket: agent-todos-0002 }
    agent-todos-0003[Add Skill /todo-creation]@{ ticket: agent-todos-0003 }
    agent-todos-0004[improve import skill]@{ ticket: agent-todos-0004 }
    agent-todos-0005[Add TODO_OVERVIEW.md and /todo-overview skill]@{ ticket: agent-todos-0005 }
    common-0001[Describe plugins in readme]@{ ticket: common-0001 }
    skill-teaching-0000[Error when excecuting script]@{ ticket: skill-teaching-0000 }
```

## Progress, Decisions etc.

### 2026-02-07: Implemented script-based Kanban visualization

**What was done:**

- Updated `plugins/agent-todos/skills/todo-overview/scripts/update-overview.sh` to generate a `## Todo Kanban` Mermaid section in `docs/agent-todos/TODO_OVERVIEW.md`.
- Ensured Kanban cards are generated in the required form: `category-0000[Title]@{ ticket: category-0000 }`.
- Built ticket IDs from real todo filenames and category names, and used frontmatter `title` values for labels.
- Kept the board lanes to `new`, `ready`, `doing`, and `done`, and excluded `archived` from visualization.
- Synced the same script changes to `.codex/skills/todo-overview/scripts/update-overview.sh`.

**Decisions made:**

- Included all todos in the table output but excluded `archived` only from the Kanban board, matching the requirement to hide archived cards from the visual board.
- Reused the existing `/todo-overview` generation flow instead of creating a separate visualization script to keep one source of truth.
