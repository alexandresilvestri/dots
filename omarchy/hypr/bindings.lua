hl.unbind("SUPER + T")
hl.unbind("SUPER + S")
hl.unbind("SUPER + F")

o.bind("SUPER + T", "Tmux", o.launch([[xdg-terminal-exec --dir="$(omarchy-cmd-terminal-cwd)" bash -c "tmux attach || tmux new"]]))
o.bind("SUPER + S", "Music", o.launch_sole("spotify", "flatpak run com.spotify.Client"))
o.bind("SUPER + E", "File manager", o.launch("nautilus --new-window"))
o.bind("SUPER + F", "Firefox", o.launch("firefox"))
o.bind("ALT + F4", "Close window", hl.dsp.window.close())
