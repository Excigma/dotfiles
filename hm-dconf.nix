{ lib, ... }: {
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

      { # gnome/desktop
        "org/gnome/desktop/background" = {
          color-shading-type = "solid";
          picture-options = "zoom";
          picture-uri = "file://${config.home.homeDirectory}/.local/share/backgrounds/SolidDesert-Light.png";
          picture-uri-dark = "file://${config.home.homeDirectory}/.local/share/backgrounds/SolidDesert-Dark.png";
        };
        "org/gnome/desktop/calendar" = { show-weekdate = false; };
        "org/gnome/desktop/interface" = {
          accent-color = "blue";
          clock-format = "24h";
          clock-show-seconds = true;
          clock-show-weekday = true;
          color-scheme = "default";
          cursor-size = 32;
          cursor-theme = "Adwaita";
          enable-animations = true;
          enable-hot-corners = true;
          gtk-enable-primary-paste = false;
          gtk-theme = "adw-gtk3";
          icon-theme = "Tela-circle-blue";
          locate-pointer = true;
          monospace-font-name = "JetBrainsMono Nerd Font Mono 10";
          show-battery-percentage = true;
        };
        "org/gnome/desktop/notifications" = {
          show-banners = true;
          show-in-lock-screen = false;
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
        "org/gnome/desktop/session" = { idle-delay = mkUint32 300; };
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
          move-to-workspace-left = [ "<Super><Shift>Page_Up" "<Super><Shift><Alt>Left" "<Control><Shift><Alt>Left" ];
          move-to-workspace-right =
            [ "<Super><Shift>Page_Down" "<Super><Shift><Alt>Right" "<Control><Shift><Alt>Right" ];
          move-to-workspace-up = [ "<Control><Shift><Alt>Up" ];
          panel-run-dialog = [ ];
          switch-applications = [ ];
          switch-applications-backward = [ ];
          switch-group = [ "<Super>Above_Tab" "<Alt>Above_Tab" ];
          switch-group-backward = [ "<Shift><Super>Above_Tab" "<Shift><Alt>Above_Tab" ];
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
      { # gnome/epiphany
        "org/gnome/epiphany" = { ask-for-default = false; };
        "org/gnome/epiphany/lockdown" = { disable-fullscreen = false; };
        "org/gnome/epiphany/state" = {
          is-maximized = true;
          window-size = mkTuple [ 1600 870 ];
        };
      }
      { # gnome/nautilus
        "org/gnome/nautilus/compression" = { default-compression-format = "zip"; };
        "org/gnome/nautilus/icon-view" = { default-zoom-level = "medium"; };
        "org/gnome/nautilus/list-view" = { default-zoom-level = "large"; };
        "org/gnome/nautilus/preferences" = {
          default-folder-viewer = "list-view";
          migrated-gtk-settings = true;
          recursive-search = "never";
          search-filter-time-type = "last_modified";
        };
      }
      { # gnome/settings-daemon
        "org/gnome/settings-daemon/peripherals/touchscreen" = { orientation-lock = true; };
        "org/gnome/settings-daemon/plugins/media-keys" = {
          control-center = [ "<Super>i" ];
          custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom6/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom7/"
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
          www = [ "<Super>b" ];
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
          binding = "<Super>Return";
          command = "ghostty";
          name = "Open Terminal";
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
          binding = "<Shift><Super>s";
          command = ''script --command "flameshot gui" /dev/null'';
          name = "Flameshot";
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
          binding = "<Super>n";
          command = "rnote";
          name = "Open RNote";
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5" = {
          binding = "<Super>c";
          command = "gtk-launch code.desktop";
          name = "VSCode";
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom6" = {
          binding = "<Shift><Control>Escape";
          command = "resources";
          name = "Task Manager";
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom7" = {
          binding = "AudioMute";
          command = "playerctl play-pause";
          name = "Play/pause";
        };
        "org/gnome/settings-daemon/plugins/power" = {
          ambient-enabled = false;
          sleep-inactive-ac-type = "suspend";
          sleep-inactive-battery-type = "suspend";
        };
      }
      { # gnome/shell
        "org/gnome/shell" = {
          disable-user-extensions = false;
          disabled-extensions = [ ];
          enabled-extensions = with pkgs.gnomeExtensions; [
            appindicator.extensionUuid
            alphabetical-app-grid.extensionUuid
            app-icons-taskbar.extensionUuid
            battery-health-charging.extensionUuid
            bluetooth-battery-meter.extensionUuid
            caffeine.extensionUuid
            clipboard-indicator.extensionUuid
            dim-completed-calendar-events.extensionUuid
            do-not-disturb-while-screen-sharing-or-recording.extensionUuid
            gnome-40-ui-improvements.extensionUuid
            just-perfection.extensionUuid
            launch-new-instance.extensionUuid
            middle-click-to-close-in-overview.extensionUuid
            night-theme-switcher.extensionUuid
            osd-volume-number.extensionUuid
            quick-settings-audio-panel.extensionUuid
            quick-settings-tweaker.extensionUuid
            quick-touchpad-toggle.extensionUuid
            tailscale-qs.extensionUuid
            toggle-workspace-span.extensionUuid
            user-themes.extensionUuid
            vitals.extensionUuid
          ];
          last-selected-power-profile = "balanced";
          remember-mount-password = true;
        };
        "org/gnome/shell/app-switcher" = { current-workspace-only = true; };
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
      { # gnome/shell/extensions
        "org/gnome/shell/extensions/Battery-Health-Charging" = {
          amend-power-indicator = true;
          icon-style-type = 0;
          indicator-position-max = 2;
          show-battery-panel2 = false;
          show-quickmenu-subtitle = true;
          show-system-indicator = false;
        };
        "org/gnome/shell/extensions/Bluetooth-Battery-Meter" = {
          enable-battery-indicator = true;
          enable-battery-indicator-text = true;
          enable-battery-level-text = true;
          level-indicator-color = 0;
          level-indicator-type = 0;
          swap-icon-text = false;
        };
        "org/gnome/shell/extensions/appindicator" = {
          icon-brightness = 0.0;
          icon-opacity = 255;
          icon-saturation = 0.0;
          legacy-tray-enabled = true;
          tray-pos = "right";
        };
        "org/gnome/shell/extensions/aztaskbar" = {
          dance-urgent = true;
          desaturation-factor = 0.0;
          favorites = true;
          icon-size = 18;
          icon-style = "REGULAR";
          indicator-color-focused = "rgb(127,170,214)";
          indicator-location = "BOTTOM";
          isolate-monitors = false;
          main-panel-height = mkTuple [ false 29 ];
          middle-click-action = "QUIT";
          multi-window-indicator-style = "MULTI_DASH";
          notification-badges = false;
          panel-location = "TOP";
          panel-on-all-monitors = false;
          scroll-action = "NO_ACTION";
          show-apps-button = mkTuple [ false 0 ];
          show-panel-activities-button = true;
          show-weather-by-clock = "OFF";
          unity-badges = false;
          unity-progress-bars = false;
          window-previews = false;
          window-previews-show-timeout = 600;
        };
        "org/gnome/shell/extensions/caffeine" = {
          duration-timer = 2;
          enable-fullscreen = false;
          indicator-position-max = 3;
          restore-state = false;
          show-indicator = "only-active";
        };
        "org/gnome/shell/extensions/clipboard-indicator" = {
          cache-size = 50;
          confirm-clear = false;
          disable-down-arrow = true;
          display-mode = 0;
          history-size = 50;
          keep-selected-on-clear = true;
          notify-on-copy = false;
          paste-button = false;
          preview-size = 10;
          toggle-menu = [ "<Super>v" ];
          topbar-preview-size = 1;
        };
        "org/gnome/shell/extensions/color-picker" = {
          color-picker-shortcut = [ "<Super>Print" ];
          enable-shortcut = true;
          enable-systray = false;
          notify-style = mkUint32 1;
        };
        "org/gnome/shell/extensions/gnome-ui-tune" = {
          always-show-thumbnails = true;
          hide-search = false;
          increase-thumbnails-size = "300%";
          overview-firefox-pip = false;
          restore-thumbnails-background = true;
        };
        "org/gnome/shell/extensions/just-perfection" = {
          alt-tab-icon-size = 0;
          alt-tab-small-icon-size = 0;
          alt-tab-window-preview-size = 0;
          animation = 4;
          background-menu = true;
          clock-menu-position = 0;
          clock-menu-position-offset = 0;
          controls-manager-spacing-size = 0;
          dash = false;
          dash-app-running = true;
          dash-icon-size = 0;
          dash-separator = true;
          double-super-to-appgrid = false;
          looking-glass-height = 0;
          looking-glass-width = 0;
          max-displayed-search-results = 25;
          notification-banner-position = 1;
          osd = true;
          osd-position = 0;
          overlay-key = true;
          panel = true;
          panel-button-padding-size = 0;
          panel-icon-size = 0;
          panel-in-overview = true;
          panel-indicator-padding-size = 0;
          panel-notification-icon = true;
          panel-size = 30;
          power-icon = true;
          ripple-box = true;
          search = true;
          show-apps-button = true;
          startup-status = 0;
          support-notifier-showed-version = 34;
          support-notifier-type = 0;
          switcher-popup-delay = true;
          theme = false;
          top-panel-position = 0;
          window-demands-attention-focus = true;
          window-maximized-on-create = false;
          window-picker-icon = true;
          window-preview-caption = true;
          window-preview-close-button = true;
          workspace = true;
          workspace-background-corner-size = 0;
          workspace-peek = true;
          workspace-popup = true;
          workspace-switcher-should-show = true;
          workspace-switcher-size = 15;
          workspace-wrap-around = false;
          workspaces-in-app-grid = true;
        };
        "org/gnome/shell/extensions/nightthemeswitcher/commands" = {
          enabled = true;
          sunrise = ''zsh -c "~/.local/bin/scripts/light_theme.sh"'';
          sunset = ''zsh -c "~/.local/bin/scripts/dark_theme.sh"'';
        };
        "org/gnome/shell/extensions/nightthemeswitcher/time" = {
          manual-schedule = true;
          nightthemeswitcher-ondemand-keybinding = [ "<Shift><Super>t" ];
        };
        "org/gnome/shell/extensions/osd-volume-number" = {
          adapt-panel-menu = true;
          icon-position = "left";
          number-position = "right";
        };
        "org/gnome/shell/extensions/quick-settings-audio-panel" = {
          always-show-input-slider = true;
          always-show-input-volume-slider = true;
          create-mpris-controllers = true;
          create-perdevice-volume-sliders = false;
          create-sink-mixer = false;
          ignore-css = false;
          master-volume-sliders-show-current-device = false;
          media-control = "duplicate";
          merge-panel = true;
          merged-panel-position = "bottom";
          move-input-volume-slider = false;
          move-master-volume = false;
          move-output-volume-slider = false;
          mpris-controllers-are-moved = false;
          panel-position = "bottom";
          panel-type = "merged-panel";
          separate-indicator = false;
          show-current-device = false;
          version = 2;
        };
        "org/gnome/shell/extensions/quick-settings-avatar" = {
          avatar-hostname = false;
          avatar-nobackground = false;
          avatar-position = 0;
          avatar-realname = false;
          avatar-size = 43;
          avatar-username = false;
        };
        "org/gnome/shell/extensions/quick-settings-tweaks" = {
          add-unsafe-quick-toggle-enabled = false;
          datemenu-fix-weather-widget = false;
          datemenu-remove-media-control = false;
          datemenu-remove-notifications = false;
          disable-adjust-content-border-radius = true;
          disable-remove-shadow = true;
          input-always-show = false;
          input-show-selected = true;
          last-unsafe-state = false;
          list-buttons = ''
            [{"name":"SystemItem","title":null,"visible":true},{"name":"OutputStreamSlider","title":null,"visible":true},{"name":"InputStreamSlider","title":null,"visible":false},{"name":"BrightnessItem","title":null,"visible":true},{"name":"NMWiredToggle","title":null,"visible":false},{"name":"NMWirelessToggle","title":"Wi-Fi","visible":true},{"name":"NMModemToggle","title":null,"visible":false},{"name":"NMBluetoothToggle","title":null,"visible":false},{"name":"NMVpnToggle","title":null,"visible":false},{"name":"BluetoothToggle","title":"Bluetooth","visible":true},{"name":"PowerProfilesToggle","title":"Power Mode","visible":true},{"name":"NightLightToggle","title":"Night Light","visible":true},{"name":"DarkModeToggle","title":"Dark Style","visible":true},{"name":"KeyboardBrightnessToggle","title":"Keyboard","visible":false},{"name":"RfkillToggle","title":"Airplane Mode","visible":true},{"name":"RotationToggle","title":"Auto Rotate","visible":true},{"name":"CaffeineToggle","title":"Caffeine","visible":true},{"name":"TailscaleMenuToggle","title":"Tailscale","visible":true},{"name":"FeatureToggle","title":"Touchpad","visible":true},{"name":"DndQuickToggle","title":"Do Not Disturb","visible":true},{"name":"BackgroundAppsToggle","title":"No Background Apps","visible":false},{"name":"MediaSection","title":null,"visible":false}]'';
          media-control-compact-mode = false;
          media-control-enabled = true;
          notifications-enabled = false;
          notifications-integrated = true;
          output-show-selected = true;
          user-removed-buttons = [ "KeyboardBrightnessToggle" ];
          volume-mixer-enabled = false;
          volume-mixer-filtered-apps = [ "speech-dispatcher-dummy" ];
          volume-mixer-position = "bottom";
          volume-mixer-show-description = true;
          volume-mixer-show-icon = true;
        };
        "org/gnome/shell/extensions/user-theme" = { name = "Marble-blue-dark"; };
        "org/gnome/shell/extensions/vitals" = {
          alphabetize = false;
          fixed-widths = true;
          hide-icons = false;
          hot-sensors = [ "_fan_dell_ddv_cpu fan_" "_battery_rate_" "_processor_usage_" ];
          icon-style = 1;
          include-static-info = false;
          menu-centered = true;
          monitor-cmd = "resources";
          position-in-panel = 2;
          show-battery = true;
          show-fan = true;
          show-memory = false;
          show-network = false;
          show-processor = true;
          show-storage = false;
          show-system = false;
          show-temperature = false;
          show-voltage = false;
          update-time = 3;
          use-higher-precision = false;
        };
      }
      { # gnome other
        "org/gnome/gedit/preferences/editor" = { scheme = "oblivion"; };
        "org/gnome/gnome-session" = { logout-prompt = false; };
        "org/gnome/mutter" = {
          attach-modal-dialogs = false;
          center-new-windows = true;
          dynamic-workspaces = true;
          edge-tiling = true;
          experimental-features = [ ];
          overlay-key = "Super_L";
          workspaces-only-on-primary = true;
        };
        "org/gnome/tweaks" = { show-extensions-notice = false; };
      }

      { # virt-manager
        "org/virt-manager/virt-manager" = { xmleditor-enabled = true; };
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
        "org/virt-manager/virt-manager/details" = { show-toolbar = true; };
      }

      { # gtk
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
          window-size = mkTuple [ 1080 870 ];
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
