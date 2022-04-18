#!/bin/sh

# From: https://github.com/PrayagS/polybar-spotify

# Format of the information displayed
# Eg. {{ artist }} - {{ album }} - {{ title }}
# See more attributes here: https://github.com/altdesktop/playerctl/#printing-properties-and-metadata

FORMAT="{{ title }}"
CHAR_LIMIT=15
PLAYER="spotify"

playerctl --follow --player=$PLAYER metadata |
	while IFS= read -r _; do
		PLAYERCTL_STATUS=$(playerctl --player=$PLAYER status 2>/dev/null)
		EXIT_CODE=$?

		if [ $EXIT_CODE -eq 0 ]; then
			STATUS=$PLAYERCTL_STATUS
		else
			STATUS="No player is running"
		fi

		if [ "$1" = "--status" ]; then
			echo "$STATUS"
		else
			if [ "$STATUS" = "Stopped" ]; then
				# echo "No music is playing"
				echo ""
			elif [ "$STATUS" = "Paused"  ]; then
				# playerctl metadata --format "$FORMAT"
				echo ""
			elif [ "$STATUS" = "No player is running"  ]; then
				# echo "$STATUS"
				echo ""
			else
				media_name=$(playerctl --player=$PLAYER metadata --format "$FORMAT")

				# Truncate displayed name to user-selected limit
				if [ "${#media_name}" -gt "$CHAR_LIMIT" ]; then
					media_name="$(echo "$media_name" | cut -c1-$((CHAR_LIMIT-1)))…"
				fi

				echo "$media_name"
			fi
		fi
	done