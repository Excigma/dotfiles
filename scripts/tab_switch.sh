#!/bin/sh

# Map buttons to switch tabs easier - since ctrl + tab is kinda difficult to press

# Check if the active window is my current browser
active_window="$(cat /proc/$(xdotool getwindowpid $(xdotool getwindowfocus))/comm)"

if [ "$active_window" = "brave" ] ; then
	case $1 in
		prev) xdotool key --clearmodifiers ctrl+shift+Tab ;;
		next) xdotool key --clearmodifiers ctrl+Tab ;;
	esac
fi