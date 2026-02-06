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

**todo-skills** — Task management system for AI agents using file-based todos in `docs/agent-todos/`:
- `todo-init` — Initializes the todo folder structure with category subdirectories
- `todo-importing` — Imports GitHub issues into local todo files via `gh issue list`, then closes them
- `todo-processing` — Reference skill (not user-invocable) defining todo file conventions: naming (`[NNN]_description.md`), completion (`DONE_` prefix), and progress tracking format

**skill-teaching** — Syncs Claude Code skills to other AI agents (currently supports `codex` target):
- Uses `sync-skills.sh` to copy skills from `.claude/skills/` and enabled plugin caches to `.codex/skills/`
- Tracks synced skills via `.claude-synced-skills.json` manifest to avoid overwriting the target agent's own skills

## Installation

```bash
claude plugin marketplace add https://github.com/erich3000/ji-agent-skills
claude plugin install todo-skills@ji-agent-skills --scope project
claude plugin install skill-teaching@ji-agent-skills --scope project
```

## Key Conventions

- Skills use YAML frontmatter in SKILL.md to declare metadata: `name`, `description`, `allowed-tools`, `user-invocable`, `argument-hint`
- Inter-skill invocation: `todo-importing` calls `todo-processing` via the Skill tool
- `sync-skills.sh` reads `.claude/settings.json` for enabled plugins and accesses the plugin cache at `~/.claude/plugins/cache/`
- No build step, no tests, no CI — changes are purely configuration and documentation
