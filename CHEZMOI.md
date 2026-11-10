# chezmoi: uso básico

## Ideia central

- **Source**: `~/.local/share/chezmoi` (repo git, verdade única).
- **Target**: `~` real (`~/.zshrc`, `~/.config/...`).
- chezmoi **copia** source para target. Não são symlinks.
- Prefixos no source viram nomes no target:
  - `dot_zshrc` → `~/.zshrc`
  - `executable_x` → arquivo com bit de execução
  - `private_x` → permissão 0600
  - `x.tmpl` → passa por template antes de copiar

## Dia a dia

| Tarefa | Comando |
|---|---|
| Editar e aplicar | `chezmoi edit --apply ~/.zshrc` |
| Ver o que mudaria | `chezmoi diff` |
| Aplicar source no `~` | `chezmoi apply` (`-v` mostra o que fez) |
| Arquivos divergentes | `chezmoi status` |
| Versionar arquivo novo | `chezmoi add ~/.config/foo/bar` |
| App reescreveu o arquivo, puxar para o source | `chezmoi re-add` |
| Parar de versionar (mantém arquivo no `~`) | `chezmoi forget ~/.config/foo/bar` |
| Listar gerenciados | `chezmoi managed` |
| Ir para o source | `chezmoi cd` |

## Git

```sh
chezmoi git -- status
chezmoi git -- add -A
chezmoi git -- commit -m "msg"
chezmoi git -- push
```

Ou `chezmoi cd` e usar git normal.

## Outra máquina (notebook)

```sh
chezmoi init https://github.com/alexandresilvestri/dots.git --apply
```

Depois, para atualizar: `chezmoi update` (faz `git pull` + `apply`).

## Templates

- `dot_config/hypr/bindings.lua.tmpl` gera `~/.config/hypr/bindings.lua`.
- `{{ if .notebook }}` escolhe o conteúdo por máquina.
- `{{ if .wsl }}` separa Windows + WSL2 de Omarchy (ex.: `dot_claude/hooks/executable_notify-desktop.sh.tmpl`).
- Mudou `.chezmoi.toml.tmpl`? Rode `chezmoi init` em cada máquina para regenerar as variáveis.
- Testar um template: `chezmoi execute-template < arquivo.tmpl`.
- Ver variáveis disponíveis: `chezmoi data`.
- Arquivos do source que não devem ir para o `~` ficam em `.chezmoiignore`.

## Cuidados

- Editar direto no `~` e depois rodar `chezmoi apply` **sobrescreve** a edição. Use `chezmoi edit` ou rode `chezmoi re-add` antes.
- omarchy reescreve `~/.config/omarchy/shell.json` e o Claude Code reescreve `~/.claude/settings.json`. Rode `chezmoi status` e, se aparecerem, `chezmoi re-add`.
