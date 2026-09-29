# cmux-tools

`cmux-tools` provides browser workflow skills for `cmux`, focused on opening pages, navigating existing browser panes, clearing stale browser cache, and capturing screenshots efficiently inside the current workspace.

## What It Does

- Discovers the active `cmux` workspace and existing browser surfaces.
- Opens a new browser pane when none exists.
- Navigates an existing browser pane to a requested URL.
- Captures browser screenshots to a local file for inline review.
- Clears stale `cmux` browser cache and profile state when assets render incorrectly only in `cmux`.
- Prefers the `cmux` browser workflow over token-heavier screenshot alternatives.

## Skills

| Skill | Description |
| --- | --- |
| `/cmux-browser-screenshooting` | Opens or reuses a `cmux` browser pane, navigates to a target URL when needed, waits for the page to load, and captures a screenshot. |
| `/cmux-browser-navigating` | Navigates the `cmux` browser pane to a URL without taking a screenshot. Opens a split browser if none exists. |
| `/cmux-browser-cache-clearing` | Clears stale `cmux` browser cache and profile state when a page or asset renders incorrectly in `cmux` but works elsewhere. |

## Typical Usage

Install the plugin, then invoke the skill when you want Claude to inspect a page visually in `cmux`, for example to:

- Open Storybook in a browser pane.
- Navigate the current browser pane to a local dev URL.
- Capture the current browser state for review.

## Installation

```bash
claude plugin install cmux-tools@ji-agent-skills --scope project
```
