# office

`office` provides skills for manipulating Microsoft Office files, starting with PowerPoint presentation normalization.

## What It Does

- Standardizes `.pptx` slide backgrounds, fonts, and text color.
- Removes text shadows from PowerPoint text content.
- Writes a neutralized copy of the presentation next to the source file.
- Supports overriding default colors, fonts, sizes, and output path via script flags.

## Skills

| Skill | Description |
| --- | --- |
| `/powerpoint-neutralizing` | Applies a consistent visual style to a PowerPoint file by normalizing background color, fonts, font sizes, text color, and text shadow settings. |

## Typical Usage

Install the plugin, then invoke the skill when you want Claude to:

- Neutralize an existing `.pptx` deck before review or reuse.
- Standardize slide styling across a presentation.
- Produce a restyled copy without modifying the original input file.

## Installation

```bash
claude plugin install office@ji-agent-skills --scope project
```
