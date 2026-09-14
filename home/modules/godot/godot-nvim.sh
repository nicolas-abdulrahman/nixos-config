#!/usr/bin/env bash

# Define a shared Unix socket path for this project session
SOCKET="/tmp/godot-nvim.pipe"
FILE="$1"
LINE="$2"

if [ -S "$SOCKET" ]; then
    # 1. An instance is already running! Send a remote command to open the file and jump to the line
    nvim --server "$SOCKET" --remote-send "<C-\><C-N>:e $FILE<CR>:$LINE<CR>"
else
    # 2. No instance found. Spawn kitty, tell Neovim to listen on the socket, and jump to the line
    kitty -- nvim --listen "$SOCKET" +"$LINE" "$FILE"
fi
