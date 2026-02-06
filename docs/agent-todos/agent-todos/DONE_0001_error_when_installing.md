## Error when installing agent-todos plugin

A user got an error when installing the `agent-todos` plugin. Can you find out why?

### Error

```bash

 1 error:
   Failed to load hooks from
   /Users/jens/.claude/plugins/cache/ji-agent-skill
   s/agent-todos/0.0.1/hooks/hooks.json: [
     {
       "expected": "record",
       "code": "invalid_type",
       "path": [
         "hooks"
       ],
       "message": "Invalid input: expected record,
   received undefined"
     }
   ]
```

## Progress, Decisions etc.

### 2026-02-06: Root cause identified and fixed

**What was done:**

- The error was caused by an incorrect `hooks.json` format in both `agent-todos` and `skill-teaching` plugins
- Plugin hooks.json requires a top-level `"hooks"` wrapper object containing the event names, but both files had event names (`SessionStart`) directly at the top level
- Fixed both `plugins/agent-todos/hooks/hooks.json` and `plugins/skill-teaching/hooks/hooks.json` by wrapping the content in `{ "hooks": { ... } }`

**Files modified:**

- `plugins/agent-todos/hooks/hooks.json`
- `plugins/skill-teaching/hooks/hooks.json`
