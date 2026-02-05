---
name: skill-sharing
description: Share Claude Code skills with other AI agents
allowed-tools: Bash
user-invocable: true
argument-hint: <target>
---

# skill-sharing

Push Claude Code skills to other AI agents in this project.

## Usage

Run the sync script from your project root with a target agent:

```bash
bash <base_directory>/scripts/sync-skills.sh <target>
```

Where `<base_directory>` is the path shown in "Base directory for this skill:" at the top of the skill invocation.

## Available Targets

| Target | Destination     | Description        |
| ------ | --------------- | ------------------ |
| codex  | `.codex/skills` | OpenAI Codex agent |

## What It Does

1. Reads previously synced skills from manifest (`.claude-synced-skills.json`)
2. Deletes only those skills (preserves target agent's own skills)
3. Copies local skills from `.claude/skills/` (except `skill-sharing` itself)
4. Copies plugin skills from enabled plugins in `.claude/settings.json`
5. Writes updated manifest with list of synced skills

## Example

```bash
# Sync all skills to Codex
bash <base_directory>/scripts/sync-skills.sh codex
```
