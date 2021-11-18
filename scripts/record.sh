#!/bin/sh

if [ $(pgrep $1) ] ; then
	peek --stop
else
	# Use something else for this
	bspc rule -a Peek state=floating rectangle=$(slop)
	# Requires a custom fork of peek: https://github.com/Excigma/Peek
	peek --no-headerbar --auto-start --auto-close
fi