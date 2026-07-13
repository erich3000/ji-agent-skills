# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Claude Code plugin marketplace (`ji-agent-skills`) that provides plugins for AI agent workflows. It is not a compiled application — it consists of plugin metadata, skill definitions (SKILL.md files with frontmatter), and shell scripts.

**Repository**: https://github.com/erich3000/ji-agent-skills

## Communication Style

**Dense, professional, action-oriented responses:**

- Start with essential information immediately
- No AI fluff ("I'll help you...", "Let me...", "Here's what I found...")
- Professional tone: helpful but not cheerful
- Every word must serve a purpose

**ANTI-CHEERFUL GUARDRAILS:**

- No exclamation points or emojis
- No "Perfect!", "Great!", "Awesome!" responses
- No celebratory language after task completion
- No "Much better!" or enthusiasm markers
- Report facts, not feelings about outcomes
- State what was done, not how "good" it is

**When you catch yourself being cheerful:** Stop. Rewrite with factual tone.

## Basic Rules

- Ask questions if anything is uncertain, do not make any assumptions!
- Ask those questions in a numbered List, so that the user can address them easily
- for complex tasks: plan before you implement!
- use `gh` cli when working with github
- do not commit anything without permission by the user
- always use the `plugin-dev:skill-development` to create new skill
- always use the `plugin-dev:skill-reviewer` after you create or changes a skill

## Architecture

The project follows Claude Code's plugin system conventions:

- **`.claude-plugin/marketplace.json`** — Top-level marketplace definition listing all available plugins with versions
- **`plugins/<plugin-name>/.claude-plugin/plugin.json`** — Per-plugin metadata (name, description, version)
- **`plugins/<plugin-name>/skills/<skill-name>/SKILL.md`** — Skill definitions using YAML frontmatter (name, description, allowed-tools, invocability) followed by detailed instructions

### Plugins

**agent-todos** — Organizes AI agent work into structured todo files in a configurable **todo store**. The default store is `docs/agent-todos/` inside the project; users can point it to any folder, including an Obsidian vault path, via `.agent-todos.local.json`. For Obsidian users, the [task-notes plugin](https://tasknotes.dev/) is recommended for getting an overview of todos.

The plugin provides the following skills:

- `todo-init` — Sets up `.agent-todos.local.json` to configure the todo store path
- `todo-creation` — Creates a new todo file with sequential 4-digit numbering and YAML frontmatter via a bash script
- `todo-gh-issue-import` — Imports GitHub issues into the configured todo store via `gh issue list`, then closes them
- `todo-processing` — Guides agents through picking up, working on, and completing todo files; defines naming conventions (`[NNNN]_description.md`), completion (`DONE_` prefix), and progress tracking format
- `todo-moving` — Moves todo files between categories and renumbers to close gaps
  **skill-teaching** — Uses the Agent Skills open standard (from [agentskills.io](https://agentskills.io/)) to copy project-scoped skills to other agents' expected directories (e.g. `.codex/skills`):

- Only operates on project-scoped skills in `.claude/skills` and plugin skills explicitly shared via `.claude/settings.json`
- Tracks synced skills via `.claude-synced-skills.json` manifest to avoid overwriting the target agent's own skills

**hugo-blog** — Hugo blog post management skills for content creation and quality assurance:

- `hugo-new` — Creates new Hugo content files using project archetypes, with archetype discovery, path convention detection, and `hugo new` execution
- `markdown-proofreading` — Proofreads markdown files for typos, grammar, formatting consistency, and clarity (not user-invocable, activates contextually)

**obsidian** — Obsidian vault management skills:

- `obsidian-kanban` — Creates and manages Obsidian Kanban plugin board files (.md files with kanban-plugin frontmatter), covering board structure, card syntax, columns, archive, and settings

**trello2obsidian** — Converts Trello JSON exports into Obsidian-compatible notes and Kanban boards:

- `trello-import` — Converts Trello board JSON exports into Markdown notes organized by board, list, and card under `TRELLO_IMPORT/`
- `trello-convert-obsidian-kanban` — Turns `TRELLO_IMPORT/` board directories into Obsidian Kanban plugin board files
- `trello-media-download` — Downloads Trello-hosted images locally and rewrites Markdown links to local paths
- `trello-set-thumbnail` — Adds a `thumbnail` frontmatter field from the first image in each card note

**cmux-tools** — Browser workflow skills for `cmux`:

- `cmux-browser-screenshooting` — Discovers or opens a `cmux` browser pane, navigates to a URL when needed, waits for load completion, and captures a screenshot to a local file
- `cmux-browser-navigating` — Navigates the `cmux` browser pane to a URL without taking a screenshot; opens a split browser if none exists
- `cmux-browser-chatgpting` — Sends a question to the ChatGPT browser surface open in cmux, submits via the send-button fallback chain (contenteditable textarea, no keyboard events), and captures the response as a screenshot
- `cmux-browser-content-reading` — Reads text content from an already-open browser surface without navigating; discovers surface by title match, reads URL, and extracts text via `get text --selector`

**office** — Microsoft Office file manipulation skills:

- `powerpoint-neutralizing` — Applies uniform PowerPoint styling by standardizing slide background, fonts, sizes, text color, and removing text shadows in a generated output file

**git-skills** — Git workflow skills for repository maintenance:

- `git-local-branch-cleaning` — Deletes local (and matching remote) branches that are fully merged into `main`, have a gone remote tracking ref, or whose PR is merged/closed; fetches, shows candidates, and asks for confirmation before deleting

**figma** — Figma Dev Mode MCP server integration for on-demand design tools:

- `figma-mcp-setup` — Walks through enabling the Figma Dev Mode MCP server in the Figma desktop app (Preferences → Dev Mode → toggle), verifies connectivity via `curl`/`nc` on `127.0.0.1:3845`, and activates the plugin with `/plugin enable figma` + `/reload-plugins`. Avoids loading ~9 Figma tool schemas on every Claude Code session when not doing design work.
- `figma-implementing` — Takes a Figma URL, checks MCP availability, fetches component data via the Dev Mode MCP tools, detects the current repo's tech stack (framework, language, styling, tokens) from `package.json`/`CLAUDE.md`/existing files, and implements the component following repo conventions.

## Installation

```bash
claude plugin marketplace add https://github.com/erich3000/ji-agent-skills
claude plugin install agent-todos@ji-agent-skills --scope project
claude plugin install skill-teaching@ji-agent-skills --scope project
claude plugin install hugo-blog@ji-agent-skills --scope project
claude plugin install obsidian@ji-agent-skills --scope project
claude plugin install trello2obsidian@ji-agent-skills --scope project
claude plugin install cmux-tools@ji-agent-skills --scope project
claude plugin install office@ji-agent-skills --scope project
claude plugin install figma@ji-agent-skills --scope project
claude plugin install git-skills@ji-agent-skills --scope project
```

## Development Workflow

- To add a new plugin: create `plugins/<name>/.claude-plugin/plugin.json` and add an entry to `.claude-plugin/marketplace.json`
- To add a new skill: use the `plugin-dev:skill-development` skill, then review with `plugin-dev:skill-reviewer`
- To test locally: install the plugin with `claude plugin install <name>@ji-agent-skills --scope project`

## Key Conventions

- Skills use YAML frontmatter in SKILL.md to declare metadata: `name`, `description`, `allowed-tools`, `user-invocable`, `argument-hint`
- Inter-skill invocation: `todo-gh-issue-import` calls `todo-creation` and `todo-processing` via the Skill tool
- `sync-skills.sh` reads `.claude/settings.json` for enabled plugins and accesses the plugin cache at `~/.claude/plugins/cache/`
- No build step, no tests, no CI — changes are purely configuration and documentation
