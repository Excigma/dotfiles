export QT_QPA_PLATFORMTHEME=qt5ct
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true'
export _JAVA_AWT_WM_NONREPARENTING=1
export LIBVA_DRIVER_NAME=iHD
export VDPAU_DRIVER=va_gl
export SXHKD_SHELL='/usr/bin/dash'
export MOZ_USE_XINPUT2=1

if [ -n "$DESKTOP_SESSION" ];then
    eval $(gnome-keyring-daemon --start)
    export SSH_AUTH_SOCK
fi
