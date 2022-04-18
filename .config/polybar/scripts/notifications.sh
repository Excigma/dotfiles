#!/bin/sh

dnd_off_color="#ffffff"
dnd_on_color="#ffffff"
# dnd_on_color="#f71616"

watch() {
	xfconf-query -c xfce4-notifyd -p /do-not-disturb -m | while read; do
	state=$(xfconf-query -c xfce4-notifyd -p /do-not-disturb)
			case "$state" in
				true) echo "  %{F$dnd_on_color}ﮖ%{F-}";;
				false) echo "  %{F$dnd_off_color}%{F-}";;
			esac
		echo ""
	done
}

case $1 in
	watch) watch ;;
	config) xfce4-notifyd-config ;;
	toggle) xfconf-query -c xfce4-notifyd -p /do-not-disturb -T ;;
	*) exit 1 ;;
esac
