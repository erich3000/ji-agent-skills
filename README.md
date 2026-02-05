# ji-agent-skills

A collection of Claude Code plugins for AI agent workflows and skill sharing.

See the [Plugins Reference](https://code.claude.com/docs/en/plugins-reference) for general information on Claude Plugins.

## Available Plugins

| Plugin          | Description                                  |
| --------------- | -------------------------------------------- |
| `todo-skills`   | Agent todo file management skills            |
| `skill-sharing` | Share Claude Code skills with other AI agents |

## Installation

### Add the Marketplace

```bash
claude plugin marketplace add https://github.com/erich3000/ji-agent-skills
```

### Install a Plugin

```bash
claude plugin install todo-skills@ji-agent-skills --scope project
```

Or for skill sharing:

```bash
claude plugin install skill-sharing@ji-agent-skills --scope project
```

## Usage

- **todo-skills**: Manage agent todo files, organize workflows, and track progress
- **skill-sharing**: Share and sync Claude Code skills with other AI agents
