# ji-agent-skills

A collection of Claude Code plugins for AI agent workflows and skill sharing.

See the [Plugins Reference](https://code.claude.com/docs/en/plugins-reference) for general information on Claude Code plugins.

## Available Plugins

| Plugin            | Description                                                | Docs                                                  |
| ----------------- | ---------------------------------------------------------- | ----------------------------------------------------- |
| `agent-todos`     | Agent todo management, moving, and overview skills         | [agent-todos.md](docs/plugins/agent-todos.md)         |
| `skill-teaching`  | Share Claude Code skills with other AI agents              | [skill-teaching.md](docs/plugins/skill-teaching.md)   |
| `hugo-blog`       | Hugo blog post management skills                           | [hugo-blog.md](docs/plugins/hugo-blog.md)             |
| `obsidian`        | Obsidian vault, Kanban, and styling skills                 | [obsidian.md](docs/plugins/obsidian.md)               |
| `trello2obsidian` | Convert Trello JSON exports into Obsidian-compatible notes | [trello2obsidian.md](docs/plugins/trello2obsidian.md) |
| `cmux-tools`      | `cmux` browser opening, navigation, and screenshot skills  | [cmux-tools.md](docs/plugins/cmux-tools.md)           |

Plugin-specific details, skill lists, and setup can be found under `docs/plugins/`.

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

```bash
claude plugin install hugo-blog@ji-agent-skills --scope project
```

```bash
claude plugin install obsidian@ji-agent-skills --scope project
```

```bash
claude plugin install trello2obsidian@ji-agent-skills --scope project
```

```bash
claude plugin install cmux-tools@ji-agent-skills --scope project
```
