{ lib, self, ... }:
{
  dconf = with lib.hm.gvariant; {
    enable = true;
    settings = lib.mkMerge [
      {
        "net/nokyan/Resources" = {
          apps-show-decoder = false;
          apps-show-drive-read-speed = true;
          apps-show-drive-write-speed = true;
          apps-show-encoder = false;
          apps-show-gpu-memory = false;
          apps-show-swap = true;
          apps-sort-by = mkUint32 1;
          apps-sort-by-ascending = false;
          detailed-priority = true;
          graph-data-points = mkUint32 80;
          is-maximized = true;
          last-viewed-page = "cpu";
          normalize-cpu-usage = true;
          processes-show-decoder = false;
          processes-show-drive-read-speed = true;
          processes-show-drive-read-total = true;
          processes-show-drive-write-speed = true;
          processes-show-drive-write-total = true;
          processes-show-encoder = false;
          processes-show-gpu-memory = false;
          processes-show-priority = false;
          processes-show-swap = false;
          processes-show-system-cpu-time = false;
          processes-show-total-cpu-time = false;
          processes-show-user-cpu-time = false;
          processes-sort-by = mkUint32 4;
          processes-sort-by-ascending = false;
          refresh-speed = "Normal";
          show-graph-grids = true;
          show-logical-cpus = true;
          show-search-on-start = true;
          show-virtual-drives = false;
          show-virtual-network-interfaces = false;
          sidebar-description = true;
          sidebar-details = true;
          sidebar-meter-type = "Graph";
        };
      }

      {
        # gnome/desktop
        "org/gnome/desktop/background" = {
          color-shading-type = "solid";
          picture-options = "zoom";
          picture-uri = "file://${self}/.local/share/backgrounds/SolidDesert-Light.png";
          picture-uri-dark = "file://${self}/.local/share/backgrounds/SolidDesert-Dark.png";
        };
        "org/gnome/desktop/calendar" = {
          show-weekdate = false;
        };
        "org/gnome/desktop/default-applications/terminal" = {
          exec = "gnome-terminal";
          exec-arg = "-x";
        };
        "org/gnome/desktop/interface" = {
          accent-color = "blue";
          clock-format = "24h";
          clock-show-seconds = true;
          clock-show-weekday = true;
          cursor-size = 32;
          cursor-theme = "Adwaita";
          enable-animations = true;
          enable-hot-corners = true;
          gtk-enable-primary-paste = false;
          icon-theme = "Tela-circle-blue";
          locate-pointer = true;
          monospace-font-name = "JetBrainsMono Nerd Font Mono 10";
          show-battery-percentage = true;
        };
        "org/gnome/desktop/notifications" = {
          show-in-lock-screen = false;
        };
        "org/gnome/desktop/screensaver" = {
          restart-enabled = true;
        };
        "org/gnome/desktop/search-providers" = {
          disable-external = false;
          disabled = [
            "firefox.desktop"
            "org.gnome.Contacts.desktop"
            "org.gnome.Calendar.desktop"
            "org.gnome.clocks.desktop"
            "org.gnome.seahorse.Application.desktop"
            "org.gnome.Epiphany.desktop"
            "org.gnome.Software.desktop"
            "org.gnome.Nautilus.desktop"
          ];
          sort-order = [
            "org.gnome.Contacts.desktop"
            "org.gnome.Documents.desktop"
            "org.gnome.Nautilus.desktop"
            "org.gnome.Calculator.desktop"
            "org.gnome.Calendar.desktop"
            "org.gnome.Characters.desktop"
            "org.gnome.clocks.desktop"
            "firefox.desktop"
            "org.gnome.seahorse.Application.desktop"
            "org.gnome.Software.desktop"
            "org.gnome.Settings.desktop"
          ];
        };
        "org/gnome/desktop/session" = {
          idle-delay = mkUint32 600;
        };
        "org/gnome/desktop/sound" = {
          allow-volume-above-100-percent = false;
          event-sounds = true;
          theme-name = "__custom";
        };
        "org/gnome/desktop/wm/keybindings" = {
          close = [ "<Super>w" ];
          cycle-group = [ ];
          cycle-group-backward = [ ];
          cycle-panels = [ ];
          cycle-panels-backward = [ ];
          move-to-monitor-down = [ "<Super><Shift>Down" ];
          move-to-monitor-left = [ "<Super><Shift>Left" ];
          move-to-monitor-right = [ "<Super><Shift>Right" ];
          move-to-monitor-up = [ "<Super><Shift>Up" ];
          move-to-workspace-down = [ "<Control><Shift><Alt>Down" ];
          move-to-workspace-left = [
            "<Super><Shift>Page_Up"
            "<Super><Shift><Alt>Left"
            "<Control><Shift><Alt>Left"
          ];
          move-to-workspace-right = [
            "<Super><Shift>Page_Down"
            "<Super><Shift><Alt>Right"
            "<Control><Shift><Alt>Right"
          ];
          move-to-workspace-up = [ "<Control><Shift><Alt>Up" ];
          switch-applications = [ ];
          switch-applications-backward = [ ];
          switch-group = [
            "<Super>Above_Tab"
            "<Alt>Above_Tab"
          ];
          switch-group-backward = [
            "<Shift><Super>Above_Tab"
            "<Shift><Alt>Above_Tab"
          ];
          switch-panels = [ ];
          switch-panels-backward = [ ];
          switch-to-workspace-left = [ "<Control><Super>Left" ];
          switch-to-workspace-right = [ "<Control><Super>Right" ];
          switch-windows = [ "<Alt>Tab" ];
          switch-windows-backward = [ "<Shift><Alt>Tab" ];
        };
        "org/gnome/desktop/wm/preferences" = {
          action-middle-click-titlebar = "minimize";
          button-layout = "icon:close";
          focus-mode = "sloppy";
          num-workspaces = 3;
          resize-with-right-button = true;
          visual-bell = false;
        };
      }
      {
        # gnome/epiphany
        "org/gnome/epiphany" = {
          ask-for-default = false;
        };
        "org/gnome/epiphany/lockdown" = {
          disable-fullscreen = false;
        };
        "org/gnome/epiphany/state" = {
          is-maximized = true;
          window-size = mkTuple [
            1600
            870
          ];
        };
      }
      {
        # gnome/nautilus
        "org/gnome/nautilus/compression" = {
          default-compression-format = "zip";
        };
        "org/gnome/nautilus/icon-view" = {
          default-zoom-level = "medium";
        };
        "org/gnome/nautilus/list-view" = {
          default-zoom-level = "large";
        };
        "org/gnome/nautilus/preferences" = {
          default-folder-viewer = "list-view";
          migrated-gtk-settings = true;
          recursive-search = "never";
          search-filter-time-type = "last_modified";
        };
      }
      {
        # gnome/settings-daemon
        "org/gnome/settings-daemon/peripherals/touchscreen" = {
          orientation-lock = true;
        };
        "org/gnome/settings-daemon/plugins/media-keys" = {
          control-center = [ "<Super>i" ];
          custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom6/"
          ];
          help = [ ];
          home = [ "<Super>e" ];
          increase-text-size = [ ];
          magnifier = [ "<Super>0" ];
          magnifier-zoom-in = [ "<Super>equal" ];
          magnifier-zoom-out = [ "<Super>minus" ];
          next = [ "<Super>AudioRaiseVolume" ];
          pause = [ ];
          play = [ ];
          previous = [ "<Super>AudioLowerVolume" ];
          search = [ ];
          volume-down = [ "AudioLowerVolume" ];
          volume-step = 2;
          volume-up = [ "AudioRaiseVolume" ];
          www = [ ];
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
          binding = "<Super>Return";
          command = "gnome-terminal";
          name = "Open Terminal";
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
          binding = "<Shift><Super>s";
          command = "gradia --screenshot=INTERACTIVE";
          name = "Screenshot with Annotations";
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
          binding = "<Super>n";
          command = "rnote";
          name = "Open RNote";
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
          binding = "<Super>c";
          command = "gtk-launch code.desktop";
          name = "VSCode";
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5" = {
          binding = "<Shift><Control>Escape";
          command = "resources";
          name = "Task Manager";
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom6" = {
          binding = "<Super>AudioMute";
          command = "playerctl play-pause";
          name = "Play/pause";
        };
        "org/gnome/settings-daemon/plugins/power" = {
          ambient-enabled = false;
          sleep-inactive-ac-type = "suspend";
          sleep-inactive-battery-type = "suspend";
        };
      }
      {
        "org/gnome/shell/app-switcher" = {
          current-workspace-only = true;
        };
        "org/gnome/shell/keybindings" = {
          focus-active-notification = [ ];
          shift-overview-down = [ "<Super><Alt>Down" ];
          shift-overview-up = [ "<Super><Alt>Up" ];
          switch-to-application-1 = [ ];
          switch-to-application-2 = [ ];
          switch-to-application-3 = [ ];
          switch-to-application-4 = [ ];
          toggle-message-tray = [ ];
          toggle-quick-settings = [ "<Super>s" ];
        };
      }
      {
        # gnome other
        "org/gnome/gedit/preferences/editor" = {
          scheme = "oblivion";
        };
        "org/gnome/gnome-session" = {
          logout-prompt = true;
        };
        "org/gnome/mutter" = {
          attach-modal-dialogs = false;
          center-new-windows = true;
          dynamic-workspaces = true;
          edge-tiling = true;
          experimental-features = [ ];
          overlay-key = "Super_L";
          workspaces-only-on-primary = true;
        };
        "org/gnome/tweaks" = {
          show-extensions-notice = false;
        };
      }

      {
        # virt-manager
        "org/virt-manager/virt-manager" = {
          xmleditor-enabled = true;
        };
        "org/virt-manager/virt-manager/confirm" = {
          delete-storage = true;
          forcepoweroff = false;
          removedev = true;
          unapplied-dev = true;
        };
        "org/virt-manager/virt-manager/console" = {
          auto-redirect = true;
          resize-guest = 1;
          scaling = 2;
        };
        "org/virt-manager/virt-manager/details" = {
          show-toolbar = true;
        };
      }

      {
        # gtk
        "org/gtk/gtk4/settings/file-chooser" = {
          date-format = "regular";
          location-mode = "path-bar";
          show-hidden = true;
          show-size-column = true;
          show-type-column = true;
          sort-column = "name";
          sort-directories-first = true;
          sort-order = "ascending";
          type-format = "category";
          view-type = "grid";
          window-size = mkTuple [
            1080
            870
          ];
        };
        "org/gtk/settings/file-chooser" = {
          clock-format = "24h";
          date-format = "regular";
          location-mode = "path-bar";
          show-hidden = false;
          show-size-column = true;
          show-type-column = true;
          sort-column = "name";
          sort-directories-first = false;
          sort-order = "ascending";
          type-format = "category";
        };
      }
    ];
  };
}
