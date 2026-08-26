hl.unbind("SUPER + S")
hl.unbind("SUPER + W")

o.bind("SUPER + S", "Music", o.launch_sole("spotify", "spotify-launcher"))
o.bind("SUPER + W", "Workspace overview", "hyprctl dispatch hyprexpo:expo toggle")
