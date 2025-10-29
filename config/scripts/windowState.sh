#!/bin/bash

workspaceInfo=$(hyprctl activeworkspace -j)
clientInfo=$(hyprctl clients -j)
activeWindowInfo=$(hyprctl activewindow -j)

window=$(echo "$workspaceInfo" | jq -r '.windows')
workspace=$(echo "$workspaceInfo" | jq -r '.id')

tiledWindows=$(echo "$clientInfo" | jq -r --arg ws "$workspace" ' [.[] | select(.workspace.id == ($ws | tonumber) and .floating == false)] | length ')
fullscreenWindow=$(echo "$activeWindowInfo" | jq -r '.fullscreen // 0')

echo "windows: $window"
echo "workspace: $workspace"
echo "tiled: $tiledWindows"
echo "fullscreen: $fullscreenWindow"
