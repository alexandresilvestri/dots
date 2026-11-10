# chezmoi: basic usage

## Core idea

- **Source**: `~/.local/share/chezmoi` (git repo, single source of truth).
- **Target**: the real `~` (`~/.zshrc`, `~/.config/...`).
- chezmoi **copies** source to target. They are not symlinks.
- Prefixes in the source become names in the target:
  - `dot_zshrc` → `~/.zshrc`
  - `executable_x` → file with the executable bit
  - `private_x` → permission 0600
  - `x.tmpl` → goes through the template engine before copying

## Day to day

| Task | Command |
|---|---|
| Edit and apply | `chezmoi edit --apply ~/.zshrc` |
| See what would change | `chezmoi diff` |
| Apply source to `~` | `chezmoi apply` (`-v` shows what it did) |
| Diverging files | `chezmoi status` |
| Track a new file | `chezmoi add ~/.config/foo/bar` |
| App rewrote the file, pull it into the source | `chezmoi re-add` |
| Stop tracking (keeps the file in `~`) | `chezmoi forget ~/.config/foo/bar` |
| List managed files | `chezmoi managed` |
| Go to the source | `chezmoi cd` |

## Git

```sh
chezmoi git -- status
chezmoi git -- add -A
chezmoi git -- commit -m "msg"
chezmoi git -- push
```

Or `chezmoi cd` and use git normally.

## Another machine (notebook)

```sh
chezmoi init https://github.com/alexandresilvestri/dots.git --apply
```

Then, to update: `chezmoi update` (runs `git pull` + `apply`).

## Templates

- `dot_config/hypr/bindings.lua.tmpl` generates `~/.config/hypr/bindings.lua`.
- `{{ if .notebook }}` picks the content per machine.
- `{{ if .wsl }}` separates Windows + WSL2 from Omarchy (e.g. `dot_claude/hooks/executable_notify-desktop.sh.tmpl`).
- Changed `.chezmoi.toml.tmpl`? Run `chezmoi init` on each machine to regenerate the variables.
- Test a template: `chezmoi execute-template < file.tmpl`.
- See available variables: `chezmoi data`.
- Source files that must not go to `~` belong in `.chezmoiignore`.

## Caveats

- Editing directly in `~` and then running `chezmoi apply` **overwrites** the edit. Use `chezmoi edit` or run `chezmoi re-add` first.
- omarchy rewrites `~/.config/omarchy/shell.json` and Claude Code rewrites `~/.claude/settings.json`. Run `chezmoi status` and, if they show up, `chezmoi re-add`.
