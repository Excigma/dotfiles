#!/bin/sh

xrandr --newmode "1920x1080_59.93"  172.60  1920 2040 2248 2576  1080 1081 1084 1118  -HSync +Vsync
xrandr --addmode HDMI-2 1920x1080_59.93
xrandr --output HDMI-2 --mode 1920x1080_59.93 --right-of eDP-1

x11vnc -clip 1920x1080+1920+0 -rfbauth ~/.vnc/passwd &
# x11vnc -rfbauth ~/.vnc/passwd &


# AJ7N3g5i6cJEV88EFWCPB9qM3W6YXx2twoWmQEU6BeVkGXVuBKMVNpLkSU2mw5hLgvoWopg8SAQw
cat ~/.vnc/passwd | ssh -T 192.168.0.129 "DISPLAY=:0 vncviewer -passwd <(cat -) 192.168.0.170:5900"