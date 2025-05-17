#!/bin/sh

dconf write /org/gnome/shell/extensions/user-theme/name "'Marble-blue-dark'"
dconf write /org/gnome/desktop/interface/gtk-theme "'adw-gtk3-dark'"
# sed -i 's/style=Adwaita/style=Adwaita-Dark/g' ~/.config/qt5ct/qt5ct.conf &
