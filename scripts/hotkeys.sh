#!/bin/sh

# Hotkey -> Text expansions, previously used them as hotstrings in Autohotkey,
# but I guess this is easier here

zero_width() {
	xdotool type '​'
}

date_time() {
	current_date_time=$(date)
	xdotool type "$current_date_time"
}

# Wait until all keys are released
while for did in $(xinput --list --id-only) ; do xinput query-state "$did" 2>/dev/null | grep down ; done | egrep -q . ; do sleep 0.1 ; done


case $1 in
	zero_width) zero_width ;;
	date_time) date_time ;;
	*) exit 1 ;;
esac