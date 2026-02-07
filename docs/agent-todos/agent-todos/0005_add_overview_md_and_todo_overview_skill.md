---
title: "Add overview.md and /todo-overview skill"
status: ready
---

## Problem / Context

Use the `/skill-development` skill to implement this work. We want an `overview.md` file in `docs/agent-todos/` that gives the user an overview over all todos as a markdown table with `category`, `todo`, and `status`. We also want a `/todo-overview` skill that creates and updates `overview.md`, and this skill should be triggered by any other skill that adds todos or changes todo status.

## Tasks

- [ ] Use `/skill-development` to implement the requested changes
- [ ] Add `docs/agent-todos/overview.md` with a markdown table of `category`, `todo`, and `status`
- [ ] Create a `/todo-overview` skill that creates and updates `overview.md`
- [ ] Ensure the `/todo-overview` skill is triggered by skills that add todos or change todo statuses
