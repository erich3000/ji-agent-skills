## Bug report

A user reported an error when executing /skill-teaching.

`The script runs from $PWD. It likely ran from a
  different directory. Let me run it explicitly
  from the project root.`

## Progress, Decisions etc.

### 2026-02-06: Fixed PROJECT_ROOT detection

**What was done:**

- Root cause: `sync-skills.sh` line 10 set `PROJECT_ROOT="$PWD"`, which breaks when the script is invoked from a directory other than the project root
- Changed `sync-skills.sh` to accept project root as an optional second argument: `sync-skills.sh <target> [project-root]`, falling back to `$PWD`
- Updated `SKILL.md` to pass `<project_root>` in the invocation examples so Claude Code always provides it

**Files modified:**

- `plugins/skill-teaching/skills/skill-teaching/scripts/sync-skills.sh`
- `plugins/skill-teaching/skills/skill-teaching/SKILL.md`