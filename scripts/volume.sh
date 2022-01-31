#!/bin/sh

notif () {
	volume=$(pamixer --get-volume)
	notify-send.py -i audio-volume-medium-symbolic "Volume: " --hint int:value:"$volume" --replaces-process "excigma-volume-change";
}

up() {
	pactl set-sink-volume @DEFAULT_SINK@ +1%
	sleep 0.01
	pactl set-sink-volume @DEFAULT_SINK@ +1%
	notif
}

down() {
	pactl set-sink-volume @DEFAULT_SINK@ -1%
	sleep 0.01
	pactl set-sink-volume @DEFAULT_SINK@ -1%
	sleep 0.01
	pactl set-sink-volume @DEFAULT_SINK@ -1%
	sleep 0.01
	pactl set-sink-volume @DEFAULT_SINK@ -1%
	notif
}

case $1 in
	mute) pactl set-sink-mute @DEFAULT_SINK@ toggle ;;
	up) up ;;
	down) down ;;
	*) exit 1 ;;
esac