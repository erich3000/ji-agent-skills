# Repository Guidelines

## Project Structure & Module Organization
This repository is a Claude Code plugin marketplace. There is no compiled app; it is mostly metadata and skill documentation.

- `.claude-plugin/marketplace.json` defines the marketplace and available plugins.
- `plugins/<plugin-name>/.claude-plugin/plugin.json` stores per-plugin metadata.
- `plugins/<plugin-name>/skills/<skill-name>/SKILL.md` contains skill definitions and instructions.
- `plugins/skill-teaching/skills/skill-teaching/scripts/sync-skills.sh` syncs skills to other agents.

## Build, Test, and Development Commands
There is no build, test, or CI workflow. Typical usage is installing the plugin into Claude Code:

- `claude plugin marketplace add https://github.com/erich3000/ji-agent-skills` adds this marketplace.
- `claude plugin install agent-todos@ji-agent-skills --scope project` installs the `agent-todos` plugin.
- `claude plugin install skill-teaching@ji-agent-skills --scope project` installs the `skill-teaching` plugin.

## Coding Style & Naming Conventions
- Skill definitions are Markdown with YAML frontmatter. Keep frontmatter keys in lowercase (for example `name`, `description`, `allowed-tools`, `user-invocable`, `argument-hint`).
- Skill files must be named `SKILL.md` and live under `plugins/<plugin>/skills/<skill>/`.
- Use concise, descriptive plugin and skill names with hyphens (for example `agent-todos`, `skill-teaching`).

## Testing Guidelines
There are no automated tests or coverage requirements. Validate changes by reviewing the affected `SKILL.md` files and plugin metadata for correctness.

## Commit & Pull Request Guidelines
Commit history is minimal and uses short, imperative summaries (for example `added plugin`). Follow that style.

When opening a PR:
- Describe what plugin/skill changed and why.
- Link related issues if applicable.
- Include example install/usage commands when behavior changes.

## Security & Configuration Tips
The `skill-teaching` plugin reads from `.claude/settings.json` and the Claude plugin cache at `~/.claude/plugins/cache/`. Avoid committing any local settings or generated caches.
