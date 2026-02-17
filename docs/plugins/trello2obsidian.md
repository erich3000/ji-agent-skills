# trello2obsidian

Obsidian vault and import tooling for converting Trello board exports into structured Markdown notes, Kanban boards, and locally stored media.

## What It Does

Reads Trello export files (`*.json`) and converts each card into one Markdown note with YAML frontmatter, organized as `TRELLO_IMPORT/<Board>/<List>/<Card>/index.md`.

Each generated note can include:

- Card title and metadata (`title`, `board`, `list`, `trello_url`)
- Description content
- Attachment links (images rendered inline where possible)

## Skills

| Skill                            | Description                                                                                              |
| -------------------------------- | -------------------------------------------------------------------------------------------------------- |
| `trello-import`                  | Converts Trello export JSON files into Obsidian notes at `TRELLO_IMPORT/<Board>/<List>/<Card>/index.md`. |
| `trello-media-download`          | Downloads Trello-hosted images to local card folders and rewrites image links in `index.md`.             |
| `trello-set-thumbnail`           | Sets a `thumbnail` frontmatter value from the first image found in each card note.                       |
| `trello-convert-obsidian-kanban` | Builds an Obsidian Kanban board file from imported Trello board/list/card folders.                       |

## Recommended Workflow

1. Export one or more boards from Trello as JSON and place the files in the repo root.
2. Run `trello-import` to generate the base note structure in `TRELLO_IMPORT/`.
3. Make your Trello boards public so that image attachments can be downloaded.
4. Run `trello-media-download` to download image attachments from Trello and rewrite note links.
5. Run `trello-set-thumbnail` to populate frontmatter thumbnails for visual browsing.
6. Run `trello-convert-obsidian-kanban` to generate board-level Kanban files for list/card overview.
7. Open the vault in Obsidian and spot-check notes and Kanban boards.

## Notes

- Running the importer recreates per-board output directories in `TRELLO_IMPORT/`.
- Keep generated files inside `TRELLO_IMPORT/` to avoid mixing source and generated content.

## Installation

```bash
claude plugin install trello2obsidian@ji-agent-skills --scope project
```
