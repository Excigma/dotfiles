#!/bin/dash

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

shadow_class() {
	bspc subscribe node_state | while read -r _ _ _ node state status; do
		if [ "$state" = "floating" ]; then
			case "$status" in
				on) xprop -id "$node" -f _BSPWM_FLOATING 32c -set _BSPWM_FLOATING 1;;
				off) xprop -id "$node" -remove _BSPWM_FLOATING;;
			esac
		fi
	done
}

case $1 in
	resize) resize "$2" ;;
	shadow_class) shadow_class ;;
	*) exit 1 ;;
esac