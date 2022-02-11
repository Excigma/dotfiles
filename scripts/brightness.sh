#!/bin/sh

notif () {
	brightness=$(brightnessctl -m | cut -d, -f4 | tr -d %)
	if [ "$brightness" -lt "51" ]; then 
		notify-call -i display-brightness-low-symbolic "Brightness:" -R "excigma-brightness-change" --hint int:value:"$brightness";
	else
		notify-call -i display-brightness-high-symbolic "Brightness:" -R "excigma-brightness-change" --hint int:value:"$brightness";
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