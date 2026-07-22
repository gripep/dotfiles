# Style guide

Conventions for the shell scripts in this repository. Follow them when adding
or editing scripts so the codebase stays consistent.

## Script header

- Start every script with `#!/usr/bin/env bash`, including files that are only
  ever `source`d. It documents the intended interpreter and keeps editors happy.
- Follow the shebang with a single `# This script ...` line describing its
  purpose. Add a short block of context only when it earns its place.

## Error handling (`set` flags)

- Scripts that are executed directly (`bin/is-*`) enable `set -eu -o pipefail`
  near the top.
- `install.sh` is `source`d (per the README) but isolates itself in a subshell
  that runs under `set -eu -o pipefail`, so a failure or `exit` cannot leak into
  and kill the caller's interactive shell.
- Scripts that are `source`d by another script (e.g. `install/*.sh`,
  `macos/*.sh`) inherit the caller's options and do not re-declare them. The
  exception is a sourced script that can also be run standalone or is
  security-sensitive (e.g. `install/github-autokey.sh`, which creates and
  uploads an SSH key): it keeps its own `set -eu -o pipefail` as a safety net.
- Relax `-e` only for deliberate best-effort scripts that must continue past
  individual failures, using `set -u` alone:
  - `clean.sh` keeps removing files even if one `rm` fails.
  - `bin/dotfiles` orchestrates best-effort steps (macOS `defaults`, package
    updates) that should not abort the whole command on a single failure. A
    sourced config guard (e.g. in `macos/defaults.sh`) may still `exit` to stop
    on invalid input.

## Variables

- Always quote expansions: `"$HOME"`, `"$DOTFILES_DIR/bin"`.
- Prefer bare `$VAR`. Use `${VAR}` only when the variable abuts other
  characters (`${PUB_KEY_NAME}.pub`) or when braces genuinely aid readability.
- Keep each file internally consistent.

## Binary and OS checks

Use the helpers in `bin/` instead of raw `command -v` / `uname`:

- `is-executable <cmd>` — is a command available on `PATH`?
- `is-macos` — is the OS macOS?
- `is-arm64` — is the CPU Apple Silicon?

```bash
if ! is-executable brew; then
    echo "Homebrew not found. Installing..."
fi
```

## Environment variables

- `.env` holds machine config and secrets and is never loaded into interactive
  shells (see `zsh/.zshrc`).
- A script that needs those values sources `.env` itself (e.g.
  `macos/defaults.sh`, `install/github-autokey.sh`) rather than relying on a
  caller to provide them, and validates the values it requires before use.

## Confirmation prompts

Destructive actions prompt with the same shape. Keep the abort on its own
statement (use `;`, not `&&`, so a failed `echo` cannot skip the exit and let
execution fall through to the destructive command). Use `exit` in a top-level
script and `return` inside a function.

```bash
printf "Continue? [y/N] "
read -r reply
case "$reply" in
    y | Y) ;;
    *) echo "Aborted."; exit 0 ;;   # in a function: return 1
esac
```

## Progress output

Announce long-running steps with a present-tense `echo` (`"Installing ..."`,
`"Updating ..."`) and confirm completion (`"... complete."`). When a step is
skipped because it is already done, say so (`"... already installed. Continue..."`).
