#!/bin/sh

notif () {
	brightness=$(brightnessctl -m | cut -d, -f4 | tr -d %)
	if [ "$brightness" -lt "51" ]; then
		notify-send.py -i display-brightness-low-symbolic "Brightness:" --replaces-process "excigma-brightness-change" --hint int:value:"$brightness";
	else
		notify-send.py -i display-brightness-high-symbolic "Brightness:" "joy" --replaces-process "excigma-brightness-change" --hint int:value:"$brightness";
	fi
}

up() {
	brightnessctl set 2+% -e
	brightnessctl set 2+% -e
	notif
}

down() {
	brightnessctl set 2-% -e
	brightnessctl set 2-% -e
	notif
}

case $1 in
	up) up ;;
	down) down ;;
	*) exit 1 ;;
esac