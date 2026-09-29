# agent-skills

`agent-skills` keeps a project's skills in one visible `agent-skills/` folder at the project root and links the agents to it with relative symlinks. Built for projects inside note apps such as Obsidian, which do not reliably sync hidden folders like `.claude/`.

```text
agent-skills/                        # canonical source, visible and synced
.claude/skills -> ../agent-skills    # Claude Code
.agents/skills -> ../agent-skills    # Codex
```

## What It Does

- Copies the skills from one existing hidden folder (`.claude/skills`, `.agents/skills` or `.codex/skills`) into `agent-skills/`, verifies the copies and then deletes the source folder. No backup is kept.
- Adds the hidden skill folders to an existing `.gitignore`.
- Creates the symlinks idempotently, with a `--check` mode, and never overwrites a real folder.
- Reports files a `SKILL.md` names but that are missing, e.g. scripts a note app did not sync.
  Obsidian Sync needs "Sync all other types" enabled on every device for `.sh` and `.py` files.

## Skills

| Skill | Description |
| --- | --- |
| `/agent-skills-init` | One-time migration from a hidden skills folder into `agent-skills/`, with dry run and conflict detection. |
| `/agent-skills-share` | Creates or checks the symlinks for Claude Code and Codex. Run once per device after syncing. |

## Limitations

- macOS and Linux only.
- Codex finds the skills only when started in the project root, unless the project is a git repository.

## Installation

```bash
claude plugin install agent-skills@ji-agent-skills --scope project
```
