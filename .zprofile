export QT_STYLE_OVERRIDE=kvantum
export QT_QPA_PLATFORMTHEME=qt5ct
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true'
export _JAVA_AWT_WM_NONREPARENTING=1
export LIBVA_DRIVER_NAME=iHD
export VDPAU_DRIVER=va_gl
export ZEITGEIST_DATABASE_PATH=':memory:'
export SXHKD_SHELL='/usr/bin/sh'

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
    exec startx -- vt1 &> /dev/null
fi
