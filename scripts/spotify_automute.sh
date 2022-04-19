#!/bin/sh

volume=$(pamixer --get-volume)

playerctl -aF -i spotify status | while read -r state; do
	if [[ "$state" == "Playing" ]]; then
		# Change volume back to saved volume
		pactl set-sink-volume @DEFAULT_SINK@ "$volume%"
		# Pause Spotify
		playerctl -p spotify pause
	else
		# Paused, Stopped

		# Save the volume that was used to watch videos
		volume=$(pamixer --get-volume)
		# "Default" Spotify volume that works for me
		pactl set-sink-volume @DEFAULT_SINK@ 18%
		# Play Spotify again
		playerctl -p spotify play
	fi
done