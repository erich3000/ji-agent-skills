# Add Status to Todo Files

## Task

- Add YAML frontmatter to todo files with two fields: `title` and `status`
- Status values: `new`, `ready`, `doing`, `done`, `archived`
- When a todo is created it gets status `new`
- After the user enters text it gets status `ready`
- The `/todo-processing` skill sets status to `doing`
- When a todo is marked as done it gets status `done`
- The `archived` status is not used for now
- Create a `/todo-migration` skill that scans all existing todo files and adds the frontmatter
- The title is generated from the filename by replacing underscores and hyphens with spaces
- Existing todos with text content get status `ready`
- Existing todos with the `DONE_` prefix get status `done`
