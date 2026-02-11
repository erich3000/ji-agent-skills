# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Claude Code plugin marketplace (`ji-agent-skills`) that provides plugins for AI agent workflows. It is not a compiled application — it consists of plugin metadata, skill definitions (SKILL.md files with frontmatter), and shell scripts.

**Repository**: https://github.com/erich3000/ji-agent-skills

## Architecture

The project follows Claude Code's plugin system conventions:

- **`.claude-plugin/marketplace.json`** — Top-level marketplace definition listing all available plugins with versions
- **`plugins/<plugin-name>/.claude-plugin/plugin.json`** — Per-plugin metadata (name, description, version)
- **`plugins/<plugin-name>/skills/<skill-name>/SKILL.md`** — Skill definitions using YAML frontmatter (name, description, allowed-tools, invocability) followed by detailed instructions

### Plugins

**agent-todos** — Organizes AI agent work into structured todo files under `docs/agent-todos/`. Formalizes a workflow where detailed prompts and context live in Markdown files instead of ad hoc CLI messages, making tasks easier to review, share, and track across a team:
- `todo-init` — Initializes the todo folder structure with category subdirectories
- `todo-creation` — Creates a new todo file with sequential 4-digit numbering and YAML frontmatter via a bash script
- `todo-gh-issue-import` — Imports GitHub issues into local todo files via `gh issue list`, then closes them
- `todo-processing` — Reference skill (not user-invocable) defining todo file conventions: naming (`[NNNN]_description.md`), completion (`DONE_` prefix), and progress tracking format
- `todo-overview` — Generates or updates `TODO_OVERVIEW.md` with a Mermaid Kanban and markdown table
- `todo-obsidian-icloud-import` — Imports todos from a local Obsidian vault synced via iCloud Drive (macOS only)
- `todo-migration` — Migrates existing projects to 4-digit prefixes and adds YAML frontmatter

**skill-teaching** — Uses the Agent Skills open standard (from [agentskills.io](https://agentskills.io/)) to copy project-scoped skills to other agents' expected directories (e.g. `.codex/skills`):
- Only operates on project-scoped skills in `.claude/skills` and plugin skills explicitly shared via `.claude/settings.json`
- Tracks synced skills via `.claude-synced-skills.json` manifest to avoid overwriting the target agent's own skills

**hugo-blog** — Hugo blog post management skills for content creation and quality assurance:
- `hugo-new` — Creates new Hugo content files using project archetypes, with archetype discovery, path convention detection, and `hugo new` execution
- `markdown-proofreading` — Proofreads markdown files for typos, grammar, formatting consistency, and clarity (not user-invocable, activates contextually)

## Installation

```bash
claude plugin marketplace add https://github.com/erich3000/ji-agent-skills
claude plugin install agent-todos@ji-agent-skills --scope project
claude plugin install skill-teaching@ji-agent-skills --scope project
claude plugin install hugo-blog@ji-agent-skills --scope project
```

## Key Conventions

- Skills use YAML frontmatter in SKILL.md to declare metadata: `name`, `description`, `allowed-tools`, `user-invocable`, `argument-hint`
- Inter-skill invocation: `todo-gh-issue-import` calls `todo-creation` and `todo-processing` via the Skill tool
- `sync-skills.sh` reads `.claude/settings.json` for enabled plugins and accesses the plugin cache at `~/.claude/plugins/cache/`
- No build step, no tests, no CI — changes are purely configuration and documentation
