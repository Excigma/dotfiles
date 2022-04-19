#!/bin/zsh

# Thanks to https://askubuntu.com/questions/211750/taking-screenshots-of-all-or-specific-virtual-desktops-workspaces-or-windows

original_ws=$(xdotool get_desktop)

# Array of workspaces with windows open
has_windows=()

# Find workspaces with windows open
for (( ws = 0; ws < $(xdotool get_num_desktops); ws++ ))
do
     # Check if workspace has windows open
     windows="$(bspc query -N -n .window -d "$ws")"

     if [[ -n $windows ]]
     then
          has_windows+=("$ws")
     fi
done

# Loop through workspaces with windows open
for ws in "${has_windows[@]}"
do
     bspc desktop -f "$ws";
     sleep 0.1

     flameshot full -r > /tmp/ws_screenshot"$ws".png;
done

# Go back to the original webspace
bspc desktop -f "$original_ws"

# Merge the image and copy to clipboard
montage /tmp/ws_screenshot*.png -tile "1x${#has_windows[@]}" -geometry 1920x1080+0+0 - | xclip -selection clipboard -t image/png -i 

notify-call "Screenshot copied to clipboard" -i "copy" 
rm /tmp/ws_screenshot*.png
