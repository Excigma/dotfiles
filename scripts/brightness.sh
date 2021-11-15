#!/bin/sh

up() {
	brightnessctl set 1%+ --exponent
	sleep 0.01
	brightnessctl set 1%+ --exponent
	sleep 0.01
	brightnessctl set 1%+ --exponent
	sleep 0.01
	brightnessctl set 1%+ --exponent
	sleep 0.01
	brightnessctl set 1%+ --exponent
}

down() {
	brightnessctl set 1%- --exponent
	sleep 0.01
	brightnessctl set 1%- --exponent
	sleep 0.01
	brightnessctl set 1%- --exponent
	sleep 0.01
	brightnessctl set 1%- --exponent
	sleep 0.01
	brightnessctl set 1%- --exponent
}

case $1 in
	up) up ;;
	down) down ;;
	*) exit 1 ;;
esac