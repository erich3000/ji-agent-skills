# ji-agent-skills

A collection of Claude Code plugins for AI agent workflows and skill sharing.

See the [Plugins Reference](https://code.claude.com/docs/en/plugins-reference) for general information on Claude Code plugins.

## Available Plugins

| Plugin           | Description                                   |
| ---------------- | --------------------------------------------- |
| `agent-todos`    | Agent todo file management skills             |
| `skill-teaching` | Share Claude Code skills with other AI agents |
| `hugo-blog`      | Hugo blog post management skills              |

### Agent Todos

`agent-todos` organizes AI agent work into structured todo files under `docs/agent-todos/`. It formalizes a workflow where detailed prompts and context live in Markdown files instead of ad hoc CLI messages, making tasks easier to review, share, and track across a team. The skills define folder structure, naming conventions, progress logging, and completion rules so agent work stays consistent and discoverable.

#### Status Lifecycle

Todo files include YAML frontmatter with a `status` field. Typical flow:

```mermaid
timeline
  title Todo Status Lifecycle
  new : Created but not yet fleshed out
  ready : Has content and can be picked up
  doing : Active work in progress
  done : Completed (also rename file with DONE_ prefix)
  archived : Reserved for future archiving
```

### Skill Teaching

`skill-teaching` uses the Agent Skills open standard (originally developed by Anthropic and published at [agentskills.io](https://agentskills.io/)) and copies project-scoped skills to other agents' expected directories (for example `.codex/skills`). It only operates on your project-scoped skills in `.claude/skills` and plugin skills you explicitly share via `.claude/settings.json`.

### Hugo Blog

`hugo-blog` provides skills for Hugo blog post management. `hugo-new` discovers project archetypes and content path conventions, then creates new content files via `hugo new`. `markdown-proofreading` reviews markdown files for typos, grammar, formatting consistency, and clarity.

## Installation

### Add the Marketplace

```bash
claude plugin marketplace add https://github.com/erich3000/ji-agent-skills
```

### Install the Plugins

```bash
claude plugin install agent-todos@ji-agent-skills --scope project
```

```bash
claude plugin install skill-teaching@ji-agent-skills --scope project
```

```bash
claude plugin install hugo-blog@ji-agent-skills --scope project
```
