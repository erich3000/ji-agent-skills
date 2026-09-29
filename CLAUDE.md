# CLAUDE.md

@AGENTS.md

## Claude Code Specifics

This file provides Claude-only guidance for Claude Code (`claude.ai/code`). Shared repository guidance lives in `AGENTS.md`.

## Claude Skills

- When creating a new skill in Claude Code, always use `plugin-dev:skill-development`.
- After creating or changing a skill in Claude Code, always use `plugin-dev:skill-reviewer`.
- The `plugin-dev:*` skill names are Claude Code plugin skills. Other agents should follow the shared `AGENTS.md` skill structure and review rules instead.

## Claude Plugin Usage

To test locally in Claude Code:

```bash
claude plugin marketplace add https://github.com/erich3000/ji-agent-skills
claude plugin install <plugin-name>@ji-agent-skills --scope project
```

Use `/reload-plugins` after changing installed plugin metadata or skill files in an active Claude Code session.
