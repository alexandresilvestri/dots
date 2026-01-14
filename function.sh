set -eg QT_QPA_PLATFORM 2>/dev/null
set -gx QT_QPA_PLATFORM xcb

export COLORTERM=truecolor

# Add Cargo bináries (Rust) to PATH
if test -d "$HOME/.cargo/bin"
    set -gx PATH "$HOME/.cargo/bin" $PATH
end

if status is-interactive # Commands to run in interactive sessions can go here

    # No greeting
    set fish_greeting

    # Use starship
    # starship init fish | source
    if test -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt
        cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt
    end

    # Aliases
    alias ls 'eza --icons'
    alias clear "printf '\033[2J\033[3J\033[1;1H'"
    alias gc 'git commit'
    alias gs 'git status'
    alias ga 'git add'
    alias gp 'git push'
    alias gch 'git checkout'
    alias dcu 'docker compose up -d'
    alias dcd 'docker compose down'
    alias arch 'sudo pacman'
    alias cat 'bat --paging=never'
    alias dc 'docker compose'
    alias dev 'devcontainer open'
    alias dev up 'devcontainer up'

end

zoxide init fish | source



# Add local bin to PATH for kubectl and other user binaries
fish_add_path $HOME/.local/bin
