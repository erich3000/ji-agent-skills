---
title: Improve plugin docs
status: done
---

## Context

To provide a better overview, each plugin should get its own README file.

## Tasks

- [x] Create a `plugins` folder under the `docs` directory.
- [x] Each plugin should have its own README file there, as a Markdown file named after the plugin (for example, `docs/plugins/agent-todos.md`).
- [x] Move plugin-related information from the general root `README.md` into the corresponding plugin README files in the docs plugin directory.
- [x] Update the general `README.md` to reference the plugin-specific README files.

## Progress, Decisions etc.

### 2026-02-17: Task started and scoped

**What was done:**

- Reviewed the todo requirements and existing root `README.md` content.
- Collected plugin metadata from `.claude-plugin/marketplace.json` and each plugin manifest.
- Scoped the implementation to create `docs/plugins/*.md` pages and simplify the root `README.md`.

### 2026-02-17: Completed plugin documentation split

**What was done:**

- Created `docs/plugins/` and added one markdown page per plugin:
  - `docs/plugins/agent-todos.md`
  - `docs/plugins/skill-teaching.md`
  - `docs/plugins/hugo-blog.md`
  - `docs/plugins/obsidian.md`
- Moved plugin-specific descriptions from root `README.md` into those plugin pages.
- Updated root `README.md` to keep a concise plugin table with direct links to each plugin doc.

**Decisions made:**

- Kept installation commands in root `README.md` so onboarding remains centralized.
- Kept richer plugin context in plugin docs to reduce root README length and improve discoverability.
