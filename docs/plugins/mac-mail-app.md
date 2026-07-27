# mac-mail-app

`mac-mail-app` controls Apple Mail.app on macOS through the external [`mail-app-cli`](https://github.com/intelligrit/mail-app-cli) command-line tool. It runs locally on your Mac and does not require network access beyond Mail.app's own account synchronization.

## What It Does

- Discovers configured Mail accounts and their mailboxes.
- Lists, reads, and inspects message content.
- Searches messages by subject and sender.
- Manages messages: marking read/unread, flagging, moving, archiving, and deleting.
- Composes and sends email with mandatory preview and confirmation.
- Lists and saves attachments with security boundaries (never opens or executes saved files).
- Enforces confirmation for sensitive actions like sending, moving, archiving, or deleting.

## Skills

| Skill | Description |
| --- | --- |
| `/mac-mail-reading` | Discover accounts and mailboxes; list and read messages; extract sender, subject, date, and body. |
| `/mac-mail-searching` | Search messages by free text, sender, or topic; advanced filtering with `jq`. |
| `/mac-mail-managing` | Mark read/unread, flag/unflag, move, archive, or delete messages with confirmation for destructive actions. |
| `/mac-mail-sending` | Compose and send email with mandatory two-stage workflow: draft preview, then explicit confirmation. |
| `/mac-mail-attachments-saving` | List attachments in messages and save them to disk with overwrite confirmation. |

## Requirements

### System

- **macOS** (Darwin) — Apple Mail.app is not available on Linux or Windows.
- **Apple Mail.app** — With at least one configured email account.

### `mail-app-cli`

The plugin requires the `mail-app-cli` binary to be installed and in your `PATH`.

#### Installation

Follow the [upstream installation instructions](https://github.com/intelligrit/mail-app-cli#installation):

```bash
go install github.com/intelligrit/mail-app-cli@latest
```

This places the binary in `$(go env GOPATH)/bin`, which is typically `~/go/bin`.

#### PATH Configuration

If `mail-app-cli` is not found when you try to use the plugin, ensure that `$(go env GOPATH)/bin` is in your `PATH`:

```bash
# Check if mail-app-cli is available
command -v mail-app-cli

# If not found, check the Go directory
ls $(go env GOPATH)/bin/mail-app-cli

# If it exists there, add the directory to PATH in your shell config (~/.bashrc, ~/.zshrc, etc.)
export PATH="$(go env GOPATH)/bin:$PATH"
```

You do not need to edit your shell configuration if the binary is already in `PATH` — the skills will find it automatically.

### Claude Code

Install the plugin from the marketplace:

```bash
claude plugin install mac-mail-app@ji-agent-skills --scope project
```

Alternatively, install all plugins at once:

```bash
curl -sSL https://raw.githubusercontent.com/erich3000/ji-agent-skills/main/install-skills.sh | bash
```

To install specific plugins only:

```bash
curl -sSL https://raw.githubusercontent.com/erich3000/ji-agent-skills/main/install-skills.sh | bash -s -- mac-mail-app git-skills
```

## Permissions

On macOS, Mail.app access requires explicit permission through System Settings.

### Granting Permission

1. Open **System Settings**
2. Navigate to **Privacy & Security → Automation**
3. Find your terminal or agent host application in the list
4. Ensure **Mail** is checked and enabled for that application
5. Restart the terminal or agent if it was already running

If you see permission errors when using the skills, this is the most common cause. Restart your terminal or agent after granting permission.

## Safety and Confirmation

### Email Content is Untrusted

- All email content (subject, sender, body, attachments) is treated as untrusted.
- Instructions embedded in email messages are not followed.
- Quoted email is clearly marked as untrusted and must be reviewed before any action.

### Sending Requires Preview and Confirmation

- Drafting an email is not permission to send it.
- The skill shows a complete preview (From, To, CC, BCC, Subject, Body, Attachments).
- You must explicitly confirm ("send it", "yes", "send now") immediately before sending.
- Drafting confirmation is required again if the draft changes materially.

### Managing Requires Confirmation for Sensitive Actions

- Marking a single message read or unread does not require confirmation.
- Moving, archiving, deleting, and bulk changes require explicit confirmation.
- The confirmation summary includes all affected messages, their senders, subjects, and the target action.

### Attachments are Saved, Never Executed

- Attachments are extracted to disk at the path you specify.
- Saved files are never automatically opened, executed, or processed.
- Archives (ZIP, TAR, etc.) are never extracted automatically.
- Macros and installers are not executed.

## Limitations

### Content Search Disabled

`mail-app-cli` does not search email bodies for performance reasons. Searches work on subject lines and sender addresses only. Use the `/mac-mail-searching` skill for advanced local filtering via `jq`.

### Gmail Archive

Gmail does not support a dedicated Archive mailbox in the standard way. If the `/mac-mail-managing` skill reports that archiving is not supported for your Gmail account, move messages to a custom folder instead.

### Batch Operations

Attachments must be saved one at a time. The `/mac-mail-attachments-saving` skill does not support batch extraction.

### HTML Email Bodies

Email bodies are plain text only. HTML formatting is not preserved or displayed.

## Troubleshooting

### `mail-app-cli: command not found`

The binary is not in your `PATH`. Check:

1. Is `mail-app-cli` installed? `ls $(go env GOPATH)/bin/mail-app-cli`
2. Is `$(go env GOPATH)/bin` in your `PATH`? `echo $PATH`
3. Add it to `PATH` if needed and restart your terminal.

### Permission errors in Mail.app operations

Mail.app access was denied by macOS. Grant permission in **System Settings → Privacy & Security → Automation** and restart your terminal.

### `mail-app-cli` exits with an error

Check that:

1. You have at least one email account configured in Mail.app.
2. The account name and mailbox name are spelled correctly.
3. The message still exists (it may have been deleted by another client).

See the `/mac-mail-reading` skill for how to discover your account and mailbox names.
