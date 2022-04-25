#!/bin/dash

notif () {
	brightness=$(brightnessctl -m | cut -d, -f4 | tr -d %)
	if [ "$brightness" -lt "51" ]; then 
		notify-call -i display-brightness-low-symbolic "Brightness:" -R "excigma-brightness-change" --hint int:value:"$brightness" --hint int:transient:1;
	else
		notify-call -i display-brightness-high-symbolic "Brightness:" -R "excigma-brightness-change" --hint int:value:"$brightness" --hint int:transient:1;
	fi
}

up() {
	brightnessctl set 4+% -e
	notif
}

down() {
	brightnessctl set 4-% -e
	notif
}

case $1 in
	up) up ;;
	down) down ;;
	*) exit 1 ;;
esac