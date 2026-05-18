# skill-teaching

`skill-teaching` helps share Claude Code skills with other coding agents.

## What It Does

- Uses the Agent Skills open standard (published at [agentskills.io](https://agentskills.io/)).
- Syncs project-scoped skills to other agents' expected directories.
- Supported targets: `codex` (`.codex/skills`), `opencode` (`.opencode/skills`), `agents` (`.agents/skills`), `gemini` (`.gemini/skills`).
- Reads from `.claude/settings.json` and the local Claude plugin cache.

## Main Skill

| Skill             | Description                                                         |
| ----------------- | ------------------------------------------------------------------- |
| `/skill-teaching` | Copies configured project skills to target agent skill directories. |

## Notes

- It operates on project-scoped skills and explicitly shared plugin skills.
- Avoid committing local settings or generated cache content.
