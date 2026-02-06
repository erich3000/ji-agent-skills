# ji-agent-skills

A collection of Claude Code plugins for AI agent workflows and skill sharing.

See the [Plugins Reference](https://code.claude.com/docs/en/plugins-reference) for general information on Claude Code plugins.

## Available Plugins

| Plugin           | Description                                   |
| ---------------- | --------------------------------------------- |
| `agent-todos`    | Agent todo file management skills             |
| `skill-teaching` | Share Claude Code skills with other AI agents |

### Agent Todos

`agent-todos` organizes AI agent work into structured todo files under `docs/agent-todos/`. It formalizes a workflow where detailed prompts and context live in Markdown files instead of ad hoc CLI messages, making tasks easier to review, share, and track across a team. The skills define folder structure, naming conventions, progress logging, and completion rules so agent work stays consistent and discoverable.

### Skill Teaching

`skill-teaching` uses the Agent Skills open standard (originally developed by Anthropic and published at [agentskills.io](https://agentskills.io/)) and copies project-scoped skills to other agents' expected directories (for example `.codex/skills`). It only operates on your project-scoped skills in `.claude/skills` and plugin skills you explicitly share via `.claude/settings.json`.

## Installation

### Add the Marketplace

```bash
claude plugin marketplace add https://github.com/erich3000/ji-agent-skills
```

### Install the Plugins

```bash
claude plugin install agent-todos@ji-agent-skills --scope project
```

```bash
claude plugin install skill-teaching@ji-agent-skills --scope project
```
