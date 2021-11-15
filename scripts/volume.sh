#!/bin/sh

up() {
	pactl set-sink-volume @DEFAULT_SINK@ +1%
	sleep 0.01
	pactl set-sink-volume @DEFAULT_SINK@ +1%
}

down() {
	pactl set-sink-volume @DEFAULT_SINK@ -1%
	sleep 0.01
	pactl set-sink-volume @DEFAULT_SINK@ -1%
	sleep 0.01
	pactl set-sink-volume @DEFAULT_SINK@ -1%
	sleep 0.01
	pactl set-sink-volume @DEFAULT_SINK@ -1%
}

case $1 in
	mute) pactl set-sink-mute @DEFAULT_SINK@ toggle ;;
	up) up ;;
	down) down ;;
	*) exit 1 ;;
esac