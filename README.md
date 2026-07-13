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
| `office`          | Microsoft Office file manipulation skills                  | [office.md](docs/plugins/office.md)                   |
| `figma`           | Figma Dev Mode MCP server integration                      | [figma.md](docs/plugins/figma.md)                     |
| `git-skills`      | Git workflow skills for repository maintenance             | [git-skills.md](docs/plugins/git-skills.md)           |

Plugin-specific details, skill lists, and setup can be found under `docs/plugins/`.

## Installation

### Claude Code

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

### Codex / other agents (no Claude Code required)

`install-skills.sh` copies skills into any agent's skills directory using only `bash` and `git`.

```bash
# All skills → .codex/skills/
curl -sSL https://raw.githubusercontent.com/erich3000/ji-agent-skills/main/install-skills.sh | bash

# Specific plugins only
curl -sSL https://raw.githubusercontent.com/erich3000/ji-agent-skills/main/install-skills.sh | bash -s -- cmux-tools git-skills

# Custom target directory
bash install-skills.sh --target .claude/skills
```
