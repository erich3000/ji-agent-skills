# skill-teaching

`skill-teaching` is deprecated. Use the `agent-skills` plugin instead.

## What It Does

- Shows an English deprecation notice.
- Points users to `agent-skills-init` for migrating existing hidden agent skill folders into `agent-skills/`.
- Points users to `agent-skills-share` for linking agent-specific skill folders to `agent-skills/`.
- Does not run the old `sync-skills.sh` workflow.

## Main Skill

| Skill             | Description                                           |
| ----------------- | ----------------------------------------------------- |
| `/skill-teaching` | Deprecated; redirects users to the `agent-skills` plugin. |

## Notes

- New workflows should use `agent-skills-init` and `agent-skills-share`.
- The old sync script remains in the plugin folder for historical compatibility, but the skill no longer instructs agents to run it.
