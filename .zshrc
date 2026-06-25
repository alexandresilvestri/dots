# p10k
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZSH_THEME="powerlevel10k/powerlevel10k"
autoload -Uz promptinit
promptinit
prompt adam1

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

setopt histignorealldups sharehistory

bindkey -e

HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
source ~/powerlevel10k/powerlevel10k.zsh-theme
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source <(fzf --zsh)

# Aliases

# --- Arch --- #
alias arch="sudo pacman"
alias update="sudo pacman -Syu && yay -Syu"
# --- Git Shortcuts ---
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gcn="git commit -n"
alias gb="git branch"
alias gch="git checkout"
alias gph="git push"
alias gpl="git pull"
alias gr="git rebase"
alias lg="lazygit"
# -- Docker --
alias d="docker"
alias dc="docker compose"
alias dcu="docker compose up -d"
alias dcd="docker compose down"
alias dvs="docker volume ls"
alias ds="docker ps"
alias ld="lazydocker"
alias dce="docker compose exec"
alias dcr="docker compose exec app bin/rails"
# -- Others --
alias codes="code backend && code frontend"
alias cat="bat --paging=never"
alias ls="exa --icons"
alias ps1="flatpak run org.duckstation.DuckStation & disown"
alias ps2="flatpak run net.pcsx2.PCSX2 & disown"
alias b="z ~"

# ------- #

# Cargo (Rust)
export PATH="$HOME/.cargo/bin:$PATH"

# Zoxide
eval "$(zoxide init zsh)"

# Mise for Ruby
eval "$(/usr/bin/mise activate)"

# ASDF
export ASDF_DATA_DIR="$HOME/.asdf"
export PATH="$ASDF_DATA_DIR/shims:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"
export LANG=en_US.UTF-8
(( ! ${+functions[p10k]} )) || p10k finalize
(( ! ${+functions[p10k]} )) || p10k finalize
(( ! ${+functions[p10k]} )) || p10k finalize
