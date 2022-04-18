# Start keyring daemon
eval $(gnome-keyring-daemon --start)
export SSH_AUTH_SOCK

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# Turn off beep, set cursor, set color
xset b off &
xsetroot -cursor_name left_ptr &
hsetroot -solid '#1b1c22' &

# Start polybar and tint
~/.config/polybar/launch.sh &
tint2 &

exec bspwm
