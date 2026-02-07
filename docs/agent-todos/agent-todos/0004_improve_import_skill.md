---
title: "improve import skill"
status: ready
---

# improve import skill

- Use the /skill-development skill to perform this task
- rename the `/todo-importing` skill into `/todo-gh-issue-import`
- the import skill needs `gh` (https://cli.github.com/) this has to be told to the user if not installed (is there a standard in anthropic skills to tell dependencies? see https://agentskills.io/specification()
- the import skill should use the /todo-creation skill for creatin a todo before inserting the content form github issue
- the status should be `ready` for todos imported by that skill.
