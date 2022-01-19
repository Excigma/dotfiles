#!/bin/sh

# Please tell me if there is a better way, this is so bad
resize() {
	bspc query -N -n focused.floating

	if [ $? -eq 0 ]; then
		# If the Window is floating then resize at the bottom right corner
		case $1 in
			left) bspc node -z right -20 0 ;;
			right) bspc node -z right 20 0 ;;
			down) bspc node -z bottom 0 20 ;;
			up) bspc node -z bottom 0 -20 ;;
			*) exit 1 ;;
		esac
	else
		# If the window is not floating, attempt to resize by moving both the left and right sides
		case $1 in
			left) (bspc node -z left -20 0 || :) && bspc node -z right -20 0 ;;
			right) (bspc node -z right 20 0 || :) && bspc node -z left 20 0 ;;
			down) (bspc node -z bottom 0 20 || :) && bspc node -z top 0 20 0 ;;
			up) (bspc node -z top 0 -20 || :) && bspc node -z bottom 0 -20 ;;
			*) exit 1 ;;
		esac
	fi

}

case $1 in
	resize) resize "$2" ;;
	*) exit 1 ;;
esac