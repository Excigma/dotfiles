#!/bin/sh

dnd_off_color="#5294e2"
dnd_on_color="#f71616"

watch() {
	xfconf-query -c xfce4-notifyd -p /do-not-disturb -m | while read; do
	state=$(xfconf-query -c xfce4-notifyd -p /do-not-disturb)
			case "$state" in
				true) echo "%{F$dnd_off_color}%{F-}";;
				false) echo "%{F$dnd_on_color}%{F-}";;
			esac
		echo ""
	done
}

case $1 in
	watch) watch ;;
	toggle) xfconf-query -c xfce4-notifyd -p /do-not-disturb -T ;;
	*) exit 1 ;;
esac
