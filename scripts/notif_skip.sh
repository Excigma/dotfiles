#!/bin/sh

dbus-monitor interface=org.freedesktop.Notifications | grep --line-buffered '!prev' | while read ; do (playerctl --player=spotify previous && playerctl --player=spotify previous); done &
dbus-monitor interface=org.freedesktop.Notifications | grep --line-buffered '!next' | while read ; do playerctl --player=spotify next ; done &
