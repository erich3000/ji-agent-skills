---
title: Describe plugins in readme
status: done
---

## Problem / Context

Enhance `README.md` by describing both plugins using the mixed-language notes below. Translate the notes to English first, then write a short description for each plugin (max 120 words). No marketing language; formal information only.

## Tasks

- [x] Translate the notes to English
- [x] Write short descriptions for each plugin (max 120 words)
- [x] Update `README.md` with the new descriptions

## Notes (Original)

### skill-teaching

- agent-skills started in claude but are an open standard now: https://agentskills.io/specification
- supported by codex (research which other agents support it too)
- the format of the files is the same but the location differs
- this skill gives Claude the ability to “teach” it skills to other agents
- this is done by copying them to the specific folder (for example .codex)
- it only operates on project scoped skilss and skill from plugings you share in .claude/settings.json

### agent-todos

- working a lot with ai agents in the past few months i learned that the quality and ausführlichkeit of your prompts have an enourmos impact on the quality of the output
- ausführliche promts in der cli zu schreiben ist angstengend, daher habe ich angefangen mardown files im project root zu schreiben und diese den agents als input zu geben, das wird aber schnell unübersichtlich und verwirrend for other team members
- die skills in diesem plugin formalisieren diesen worflow in dem sie todo files einen festen ort im docs verzeichnis geben

## Progress, Decisions etc.

### 2026-02-06: Translated Notes And Updated README

**What was done:**

- Translated the notes to English and used them to draft short plugin descriptions.
- Researched Agent Skills adoption to name other supported agents.
- Updated `README.md` with formal descriptions for `agent-todos` and `skill-teaching`.

**Translated notes (English):**

- Skill-teaching: Agent Skills started in Claude but are now an open standard. The file format is the same across agents, but locations differ. This plugin lets Claude “teach” skills to other agents by copying skills into their expected folders (e.g., `.codex/skills`). It only operates on project-scoped skills and those explicitly shared via `.claude/settings.json`.
- Agent-todos: Working with AI agents showed that prompt quality and detail strongly affect output quality. Writing long prompts in the CLI is tedious, so I began writing markdown files in the project root and passing them to agents, but this quickly became messy and confusing for other team members. These skills formalize the workflow by giving todo files a fixed location under `docs/`.
