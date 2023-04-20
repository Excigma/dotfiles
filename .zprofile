# Folders
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CACHE_HOME=$HOME/.cache

# Alternative config locations
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export GOPATH="$XDG_DATA_HOME"/go
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
export NODE_REPL_HISTORY="$XDG_DATA_HOME"/node_repl_history

# Development
export NODE_ENV=development

# Drivers for Hardware Acceleration
export LIBVA_DRIVER_NAME=iHD
export VDPAU_DRIVER=va_gl

# Let Mozilla Firefox use libinput; allows touchpad zooming and fling scrolling
export MOZ_USE_XINPUT2=1
# Enable Firefox Wayland mode
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM="wayland;xcb"
export SDL_VIDEODRIVER=wayland
export CLUTTER_BACKEND=wayland

# Make Maliit use desktop theme
export QT_QUICK_CONTROLS_STYLE=org.kde.desktop

# Kooha experimental options
# export KOOHA_EXPERIMENTAL=1
# export GST_VAAPI_ALL_DRIVERS=1

# Let GTK applications use the kde dialog
# export GTK_USE_PORTAL=1
# export GDK_DEBUG=portals

export BROWSER=firefox
export EDITOR=nano

export RUSTFLAGS="-C target-cpu=native"

export PATH=$PATH:/home/excigma/.local/bin:/home/excigma/.local/share/go/bin:/home/excigma/.local/share/cargo/bin
