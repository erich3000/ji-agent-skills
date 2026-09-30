# Repository Guidelines

## Project Overview

This repository is a Claude Code plugin marketplace (`ji-agent-skills`) for AI agent workflows. It is not a compiled application; it consists of plugin metadata, skill definitions, Markdown documentation, and shell scripts.

Repository: `https://github.com/erich3000/ji-agent-skills`

## Communication Style

Use dense, professional, action-oriented responses:

- Start with the essential information immediately.
- Do not use AI fluff such as "I'll help you", "Let me", or "Here's what I found".
- Keep a professional tone: helpful, but not cheerful.
- Every word must serve a purpose.

Anti-cheerful guardrails:

- Do not use exclamation points or emojis.
- Do not use "Perfect!", "Great!", "Awesome!", or similar responses.
- Do not use celebratory language after task completion.
- Do not use "Much better!" or enthusiasm markers.
- Report facts, not feelings about outcomes.
- State what was done, not how "good" it is.

When you catch yourself being cheerful, stop and rewrite with a factual tone.

## Basic Rules

- Ask questions if anything is uncertain; do not make assumptions.
- Ask those questions in a numbered list so the user can address them easily.
- For complex tasks, plan before implementing.
- Use the `gh` CLI when working with GitHub.
- Do not commit anything without explicit user permission.

## Project Structure & Module Organization

- `.claude-plugin/marketplace.json` defines the marketplace and available plugins.
- `plugins/<plugin-name>/.claude-plugin/plugin.json` stores per-plugin metadata for Claude Code.
- `.agents/plugins/marketplace.json` and `plugins/<plugin-name>/.codex-plugin/plugin.json` are the Codex counterparts.
- `plugins/<plugin-name>/skills/<skill-name>/SKILL.md` contains skill definitions and instructions.
- `plugins/agent-skills/` is the replacement workflow for sharing project skills across agents.
- `install-skills.sh` installs selected plugins into the visible `agent-skills/` folder without requiring Claude Code.

## Architecture

The project follows Claude Code's plugin system conventions:

- `.claude-plugin/marketplace.json` is the top-level marketplace definition listing all available plugins with versions.
- `plugins/<plugin-name>/.claude-plugin/plugin.json` is per-plugin metadata with name, description, and version.
- `plugins/<plugin-name>/skills/<skill-name>/SKILL.md` defines a skill using YAML frontmatter followed by detailed instructions.

## Plugin Inventory

Do not duplicate the full plugin and skill inventory in agent instructions. The repository files are the source of truth:

- Read `.claude-plugin/marketplace.json` for the list of published plugins and versions.
- Read `plugins/<plugin-name>/.claude-plugin/plugin.json` for plugin metadata.
- Read `plugins/<plugin-name>/skills/<skill-name>/SKILL.md` for the exact skill name, description, allowed tools, invocability, and instructions.
- Use `rg --files plugins -g 'plugin.json' -g 'SKILL.md'` or equivalent when you need an up-to-date inventory.

Update the metadata and `SKILL.md` files first. Only update `AGENTS.md` when a shared convention changes.

## Installation

### Claude Code

```bash
claude plugin marketplace add https://github.com/erich3000/ji-agent-skills
claude plugin install agent-todos@ji-agent-skills --scope project
claude plugin install hugo-blog@ji-agent-skills --scope project
claude plugin install obsidian@ji-agent-skills --scope project
claude plugin install trello2obsidian@ji-agent-skills --scope project
claude plugin install cmux-tools@ji-agent-skills --scope project
claude plugin install office@ji-agent-skills --scope project
claude plugin install figma@ji-agent-skills --scope project
claude plugin install pdf-skills@ji-agent-skills --scope project
claude plugin install agent-skills@ji-agent-skills --scope project
```

### Codex

```bash
codex plugin marketplace add erich3000/ji-agent-skills --ref main
codex plugin add agent-todos@ji-agent-skills
```

### Any Agent

`install-skills.sh` installs skills into the visible project `agent-skills/` folder. Run `agent-skills-share` afterwards on each device to link local agent folders to it. It requires only `bash` and `git`.

```bash
# Install all plugins into ./agent-skills
curl -sSL https://raw.githubusercontent.com/erich3000/ji-agent-skills/main/install-skills.sh | bash

# Specific plugins only
curl -sSL https://raw.githubusercontent.com/erich3000/ji-agent-skills/main/install-skills.sh | bash -s -- cmux-tools git-skills

# Explicit legacy target directory
bash install-skills.sh --target .codex/skills
```

## Build, Test, and Development Commands

There is no build, test, or CI workflow. Typical usage is installing the plugin into Claude Code:

- `claude plugin marketplace add https://github.com/erich3000/ji-agent-skills`
- `claude plugin install agent-todos@ji-agent-skills --scope project`
- `claude plugin install agent-skills@ji-agent-skills --scope project`

## Development Workflow

- To add a new plugin, create `plugins/<name>/.claude-plugin/plugin.json` and `plugins/<name>/.codex-plugin/plugin.json`, and add an entry to both `.claude-plugin/marketplace.json` and `.agents/plugins/marketplace.json`.
- When bumping a plugin version, change it in all three places: both `plugin.json` files and `.claude-plugin/marketplace.json`. The Codex marketplace carries no versions.
- A plugin with `.mcp.json` references it as `"mcpServers": "./.mcp.json"` in its Codex manifest. Keep the file in the `{"mcpServers": {...}}` form, which both agents read.
- To add a new skill in Claude Code, use the `plugin-dev:skill-development` skill, then review with `plugin-dev:skill-reviewer`.
- To add or edit a skill outside Claude Code, follow the existing `SKILL.md` structure, frontmatter conventions, plugin metadata conventions, and review the result manually.
- To test locally, install the plugin with `claude plugin install <name>@ji-agent-skills --scope project`, and in Codex with `codex plugin marketplace add ./` followed by `codex plugin add <name>@ji-agent-skills`. Use a temporary `CODEX_HOME` to keep your own Codex config untouched.

## Coding Style & Naming Conventions

- Skill definitions are Markdown with YAML frontmatter.
- Keep frontmatter keys in lowercase, for example `name`, `description`, `allowed-tools`, `user-invocable`, and `argument-hint`.
- Skill files must be named `SKILL.md` and live under `plugins/<plugin>/skills/<skill>/`.
- Use concise, descriptive plugin and skill names with hyphens, for example `agent-todos` and `skill-teaching`.
- Inter-skill invocation can call another skill by name when the current agent supports that workflow.
- `skill-teaching` is deprecated; use `agent-skills-init` and `agent-skills-share` for cross-agent skill sharing.

## Testing Guidelines

There are no automated tests or coverage requirements. Validate changes by reviewing the affected `SKILL.md` files and plugin metadata for correctness.

## Commit & Pull Request Guidelines

Commit history is minimal and uses short, imperative summaries, for example `added plugin`. Follow that style.

When opening a PR:

- Describe what plugin or skill changed and why.
- Link related issues if applicable.
- Include example install or usage commands when behavior changes.

## Security & Configuration Tips

The deprecated `skill-teaching` plugin previously read from `.claude/settings.json` and the Claude plugin cache at `~/.claude/plugins/cache/`. Avoid committing any local settings or generated caches.
