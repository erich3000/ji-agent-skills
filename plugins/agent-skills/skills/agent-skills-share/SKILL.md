---
name: agent-skills-share
description: This skill should be used when the user asks to "link skills for Codex and Claude", "create skill symlinks", "check skill symlinks", "set up skills on this device", "Skills verlinken", or "run agent-skills-share", and after agent-skills-init or on a new device where a synced project has agent-skills/ but no local links. Creates relative symlinks .claude/skills and .agents/skills to agent-skills/, idempotent, with --check.
---

# agent-skills-share

Links the agents' skill folders to the project's visible `agent-skills/` folder. Symlinks are
local, so every device needs one run after the project has been synced to it.

| Agent | Link |
| --- | --- |
| Claude Code | `.claude/skills -> ../agent-skills` |
| Codex | `.agents/skills -> ../agent-skills` |

The links are relative, so a moved or synced project keeps working.

## Workflow

### 1. Check

From the project root:

```bash
bash <base_directory>/scripts/share.sh --check
```

`<base_directory>` is the path shown as "Base directory for this skill". Output per link:

| Status | Meaning |
| --- | --- |
| `ok` | symlink to `../agent-skills` exists |
| `missing` | nothing there yet |
| `CONFLICT` | a real folder, a file or another symlink occupies the path; an absolute link to `agent-skills/` counts as well |

Exit code 0 means everything is linked.

### 2. Resolve conflicts

The script never overwrites anything. For a conflict:

- **Real skills folder:** its skills are not in `agent-skills/` yet, or they are stale copies.
  Invoke `agent-skills-init` with that folder as the source. It copies what is missing and
  renames the folder out of the way.
- **Symlink pointing elsewhere:** show the user where it points and ask before removing it.
- **No `agent-skills/` at all:** the script exits with code 1 and changes nothing. Run
  `agent-skills-init` first.

### 3. Create the links

```bash
bash <base_directory>/scripts/share.sh
```

Creates the missing links, confirms existing correct ones, and still reports conflicts. Running it
again is safe.

### 4. Verify

Restart the agent and confirm the project skills appear.

## Notes

- Nothing is copied, moved or deleted. The script only creates the symlinks and, if missing, the
  `.claude/` and `.agents/` folders.
- **Start the agents in the project root.** Claude Code also finds the skills when started in a
  subfolder. Codex does not if the project is not a git repository: it looks for `.agents/skills`
  only in the start folder and in parent folders up to the repository root.
- macOS and Linux only. Windows needs developer mode or admin rights for symlinks and is not
  covered.
- The symlinks are local per device, `agent-skills/` is what gets synced. `agent-skills-init` adds
  them to `.gitignore` if the project has one; otherwise add the entries by hand when needed.
