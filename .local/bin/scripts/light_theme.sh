#!/bin/sh

dconf write /org/gnome/shell/extensions/user-theme/name "'Marble-blue-light'"
dconf write /org/gnome/desktop/interface/gtk-theme "'adw-gtk3'"
# sed -i 's/style=Adwaita-Dark/style=Adwaita/g' ~/.config/qt5ct/qt5ct.conf &
