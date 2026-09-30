# ji-agent-skills

A collection of Claude Code plugins for AI agent workflows and skill sharing.

See the [Plugins Reference](https://code.claude.com/docs/en/plugins-reference) for general information on Claude Code plugins.

## Available Plugins

| Plugin            | Description                                                | Docs                                                  |
| ----------------- | ---------------------------------------------------------- | ----------------------------------------------------- |
| `agent-skills`    | Visible `agent-skills/` folder linked to Claude and Codex  | [agent-skills.md](docs/plugins/agent-skills.md)       |
| `agent-todos`     | Agent todo management, moving, and archiving skills        | [agent-todos.md](docs/plugins/agent-todos.md)         |
| `cmux-tools`      | `cmux` browser opening, navigation, screenshot, and cache skills | [cmux-tools.md](docs/plugins/cmux-tools.md)           |
| `figma`           | Figma Dev Mode MCP server integration                      | [figma.md](docs/plugins/figma.md)                     |
| `git-skills`      | Git workflow skills for repository maintenance             | [git-skills.md](docs/plugins/git-skills.md)           |
| `hugo-blog`       | Hugo blog post management skills                           | [hugo-blog.md](docs/plugins/hugo-blog.md)             |
| `mac-mail-app`    | Apple Mail.app access and management skills                | [mac-mail-app.md](docs/plugins/mac-mail-app.md)       |
| `obsidian`        | Obsidian vault, Kanban, and styling skills                 | [obsidian.md](docs/plugins/obsidian.md)               |
| `office`          | Microsoft Office file manipulation skills                  | [office.md](docs/plugins/office.md)                   |
| `pdf-skills`      | PDF compression, OCR, and XFA form skills                  | [pdf-skills.md](docs/plugins/pdf-skills.md)           |
| `skill-teaching`  | Deprecated; use `agent-skills` for skill sharing           | [skill-teaching.md](docs/plugins/skill-teaching.md)   |
| `trello2obsidian` | Convert Trello JSON exports into Obsidian-compatible notes | [trello2obsidian.md](docs/plugins/trello2obsidian.md) |

Plugin-specific details, skill lists, and setup can be found under `docs/plugins/`.

## Installation

### Claude Code

```bash
claude plugin marketplace add https://github.com/erich3000/ji-agent-skills

claude plugin install agent-skills@ji-agent-skills --scope project
claude plugin install agent-todos@ji-agent-skills --scope project
claude plugin install cmux-tools@ji-agent-skills --scope project
claude plugin install figma@ji-agent-skills --scope project
claude plugin install git-skills@ji-agent-skills --scope project
claude plugin install hugo-blog@ji-agent-skills --scope project
claude plugin install mac-mail-app@ji-agent-skills --scope project
claude plugin install obsidian@ji-agent-skills --scope project
claude plugin install office@ji-agent-skills --scope project
claude plugin install pdf-skills@ji-agent-skills --scope project
claude plugin install trello2obsidian@ji-agent-skills --scope project
```

### Codex

The repository is also a Codex plugin marketplace (`.agents/plugins/marketplace.json`, one
`.codex-plugin/plugin.json` per plugin).

```bash
codex plugin marketplace add erich3000/ji-agent-skills --ref main

codex plugin add agent-skills@ji-agent-skills
codex plugin add pdf-skills@ji-agent-skills
# ... any other plugin from the table above
```

For local development, point Codex at the checkout instead: `codex plugin marketplace add ./`
(or the absolute path). Pin a release with `--ref <tag-or-commit>` instead of `main`. After
pulling changes from GitHub, refresh with `codex plugin marketplace upgrade`.

The Claude hook files of `agent-todos` and `skill-teaching` are not part of the Codex manifests;
they only print a Claude Code restart notice.

### Any agent (no Claude Code required)

`install-skills.sh` installs skills into the visible project `agent-skills/` folder. Run
`agent-skills-share` afterwards on each device to link local agent folders to it. Requires only
`bash` and `git`.

```bash
# Install all plugins into ./agent-skills
curl -sSL https://raw.githubusercontent.com/erich3000/ji-agent-skills/main/install-skills.sh | bash

# Specific plugins only
curl -sSL https://raw.githubusercontent.com/erich3000/ji-agent-skills/main/install-skills.sh | bash -s -- cmux-tools git-skills

# Explicit legacy target directory
bash install-skills.sh --target .codex/skills
```
