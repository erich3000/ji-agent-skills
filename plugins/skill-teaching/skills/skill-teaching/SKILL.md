---
name: skill-teaching
description: This skill should be used when the user asks to "sync skills to agent", "share skills with agent", "push skills to target", "teach agent skills", or requests synchronizing Claude Code skills with other AI agents in the project.
---

# Skill Teaching

Synchronize Claude Code skills to other AI agents in the project. This enables knowledge and workflow sharing across agents while preserving each agent's own skills.

## Workflow

### Step 1: Identify Target Agent

Determine the target agent where skills should be synced:

- `codex` - OpenAI Codex agent (destination: `.codex/skills`)
- `opencode` - OpenCode agent (destination: `.opencode/skills`)
- `agents` - Generic agents folder (destination: `.agents/skills`)
- `gemini` - Gemini agent (destination: `.gemini/skills`)

### Step 2: Execute Sync Script

Run the sync script from the project root with the target agent identifier:

```bash
bash <base_directory>/scripts/sync-skills.sh <target>
```

Where `<base_directory>` is the path shown in "Base directory for this skill:" output. Pass a second argument `<project_root>` when running from a directory other than the project root (defaults to `$PWD`).

### Step 3: Verify Sync Results

The script performs these operations:

1. Reads previously synced skills from manifest (`.claude-synced-skills.json`)
2. Deletes only previously synced skills (preserves target agent's own skills)
3. Copies local skills from `.claude/skills/` (except `skill-teaching` itself)
4. Copies plugin skills from enabled plugins in `.claude/settings.json`
5. Writes updated manifest with list of synced skills

## Example Invocation

```bash
# Sync all skills to Codex agent
bash <base_directory>/scripts/sync-skills.sh codex

# Sync all skills to OpenCode agent
bash <base_directory>/scripts/sync-skills.sh opencode

# Sync all skills to generic agents folder
bash <base_directory>/scripts/sync-skills.sh agents

# Sync all skills to Gemini agent
bash <base_directory>/scripts/sync-skills.sh gemini
```

## Additional Resources

### Scripts

The skill includes a utility script for skill synchronization:

- **`scripts/sync-skills.sh`** - Executes the sync operation with manifest management. Supported targets: `codex`, `opencode`, `agents`, `gemini`.
