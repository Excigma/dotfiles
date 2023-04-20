#!/bin/zsh

up () {
	/usr/bin/brillo -q -u 20000 -A 5
	brightess=$(brillo -q)
	qdbus org.kde.plasmashell /org/kde/osdService org.kde.osdService.brightnessChanged "${brightess%.*}"
	sleep 0.05
}

down () {
	/usr/bin/brillo -q -u 20000 -U 5
	brightess=$(brillo -q)
	qdbus org.kde.plasmashell /org/kde/osdService org.kde.osdService.brightnessChanged "${brightess%.*}"
	sleep 0.05
}

case $1 in
	up) up ;;
	down) down ;;
	*) exit 1 ;;
esac
