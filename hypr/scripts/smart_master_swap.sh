#!/bin/bash
CACHE_FILE="/tmp/hypr_last_master"

current_window=$(hyprctl activewindow -j)
current_address=$(echo "$current_window" | jq -r '.address')
current_workspace=$(echo "$current_window" | jq -r '.workspace.id')

# Find master by largest window on current workspace
workspace_windows=$(hyprctl clients -j | jq ".[] | select(.workspace.id == $current_workspace)")
master_address=$(echo "$workspace_windows" | jq -s 'sort_by(.size[0] * .size[1]) | reverse | .[0].address' | tr -d '"')

# Check if current window is master
is_master=$([ "$current_address" = "$master_address" ] && echo "true" || echo "false")

if [ "$is_master" = "true" ]; then
  # We're on master - swap with the last master if it exists
  if [ -f "$CACHE_FILE" ]; then
    last_master=$(cat "$CACHE_FILE")

    # Check if the last master window still exists AND is not current window
    if hyprctl clients -j | jq -r '.[].address' | grep -q "$last_master" && [ "$last_master" != "$current_address" ]; then
      # Store current master before swap (it will become a slave)
      echo "$current_address" >"$CACHE_FILE"
      hyprctl dispatch focuswindow "address:$last_master"
      hyprctl dispatch layoutmsg swapwithmaster
    else
      # Regular swap behavior - store current master
      echo "$current_address" >"$CACHE_FILE"
      hyprctl dispatch layoutmsg swapwithmaster
    fi
  else
    # No cache file, regular swap - store current master
    echo "$current_address" >"$CACHE_FILE"
    hyprctl dispatch layoutmsg swapwithmaster
  fi
else
  # On slave - store current master and swap
  echo "$master_address" >"$CACHE_FILE"
  hyprctl dispatch layoutmsg swapwithmaster
fi
