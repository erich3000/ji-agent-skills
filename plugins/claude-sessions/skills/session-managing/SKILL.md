---
name: session-managing
description: Use when the user asks to list local Claude Code sessions, identify their terminal environment, or safely close selected old Claude sessions. Trigger phrases include "show running Claude sessions", "list running sessions", "close old sessions", "close sessions older than", and "which environment are sessions running in".
---

# Claude Session Managing

Inspect local Claude Code processes and, only after explicit user selection, end selected sessions. Never close cmux panes, terminal tabs, windows, cloud sessions, or Claude Desktop sessions.

## Safety rules

- Start read-only. Do not signal a process unless the user explicitly selects it.
- Never select or terminate the current session. The bundled script excludes the Claude ancestor of the shell that runs it; also verify that a target is not the current session immediately before signalling it.
- Treat `waiting` sessions as potentially active and call them out separately.
- Before every signal, re-run the bundled script and verify the PID, cwd, and start timestamp still match the selected session. If they do not, stop and ask the user.
- Never use `kill -9` unless the user explicitly approves it after `SIGTERM` has failed.
- Session history remains available for a terminated local session and can normally be resumed from its working directory with `claude --resume`.

## 1. Inventory local sessions

Run the bundled script. It only reads process state and emits TSV:

```bash
bash <skill-base-dir>/scripts/list-sessions.sh
```

If the skill directory is unavailable, locate `list-sessions.sh` in the installed `claude-sessions` plugin cache. It reports PID, ISO start timestamp, display date (`TT.MM.`), working directory, and inferred environment.

Use `ListAgents` as well when available. It provides session names and `idle` or `waiting` status. Match a listed agent to a process using cwd and start age. Where multiple sessions share a cwd, use their start times; if the match is still ambiguous, label it `unmatched` and ask the user instead of guessing.

Present the merged results as a compact table:

| # | PID | Session | Folder | Started | Environment | Status |
|---|-----|---------|--------|---------|-------------|--------|

Include processes that cannot be matched to `ListAgents` as `local process (unmatched)`. Cloud and desktop sessions do not have usable local PIDs and must not appear as termination targets.

## 2. Suggest, do not act

The default suggestion is `idle` sessions older than seven days. This is only a suggestion. Do not send a message or a signal until the user explicitly selects entries by number, name, or date cutoff.

Flag `waiting` rows separately because they are awaiting input. State that stale tabs may remain visible after a process exits; the user manages those tabs.

## 3. End explicitly selected sessions

First re-inventory and re-match every requested process. Then, if `SendMessage` can address the matching peer session, send a plain-language request to finish and exit. Do not send `/exit` expecting it to execute: agent messages are delivered as content, not terminal keystrokes or slash-command input.

If it does not exit, or the session cannot receive a peer message, tell the user that the next action is `SIGTERM` and require their explicit confirmation if it was not already included in their selection. Send the signal only to the verified PID:

```bash
kill -TERM <pid>
ps -p <pid> -o pid=,stat=,command=
```

Report `already ended` if the PID has disappeared. If a session remains after `SIGTERM`, ask whether to retry later or use `SIGKILL`; never use `kill -9` without that separate confirmation.

## 4. Verify

Run the inventory again and present the updated table, marking selected sessions as ended or still running. Do not close panes or windows during this verification.
