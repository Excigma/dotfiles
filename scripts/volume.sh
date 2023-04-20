#!/bin/dash

notif () {
	volume=$(pamixer --get-volume)
	notify-call -i audio-volume-medium-symbolic "Volume:" -R "excigma-volume-change" --hint int:value:"$volume" --hint int:transient:1;
}

up() {
	pactl set-sink-volume @DEFAULT_SINK@ +1%
	notif
	sleep 0.01
	pactl set-sink-volume @DEFAULT_SINK@ +1%
	notif
}

down() {
	pactl set-sink-volume @DEFAULT_SINK@ -1%
	sleep 0.01
	pactl set-sink-volume @DEFAULT_SINK@ -1%
	notif
	sleep 0.01
	pactl set-sink-volume @DEFAULT_SINK@ -1%
	sleep 0.01
	pactl set-sink-volume @DEFAULT_SINK@ -1%
	notif
}

zero() {
	pactl set-sink-volume @DEFAULT_SINK@ 1%
	notif
}

case $1 in
	toggle) pactl set-sink-mute @DEFAULT_SINK@ toggle ;;
	up) up ;;
	down) down ;;
	zero) zero ;;
	*) exit 1 ;;
esac
