{ pkgs, lib, ... }:
{
  # Install extensions
  home.packages = with pkgs; [
    (marble-shell-theme.override {
      colors = [ "blue" ];
      additionalInstallationTweaks = [
        "--opaque"
        # "--panel-default-size"
      ];
    })
    gnomeExtensions.appindicator
    gnomeExtensions.alphabetical-app-grid
    gnomeExtensions.app-icons-taskbar
    gnomeExtensions.battery-health-charging
    gnomeExtensions.bluetooth-battery-meter
    gnomeExtensions.todotxt
    gnomeExtensions.caffeine
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.dim-completed-calendar-events
    gnomeExtensions.do-not-disturb-while-screen-sharing-or-recording
    gnomeExtensions.native-window-placement
    gnomeExtensions.launch-new-instance
    gnomeExtensions.solaar-extension
    gnomeExtensions.fly-pie
    gnomeExtensions.gnome-40-ui-improvements
    gnomeExtensions.search-light
    gnomeExtensions.just-perfection
    gnomeExtensions.middle-click-to-close-in-overview
    gnomeExtensions.night-theme-switcher
    gnomeExtensions.osd-volume-number
    gnomeExtensions.quick-settings-audio-panel
    gnomeExtensions.quick-touchpad-toggle
    gnomeExtensions.tailscale-qs
    gnomeExtensions.toggle-workspace-span
    gnomeExtensions.quick-web-search
    gnomeExtensions.user-themes
    gnomeExtensions.unblank
    gnomeExtensions.vitals
  ];

  dconf = with lib.hm.gvariant; {
    enable = true;
    settings = {
      # Enable extensions
      "org/gnome/shell" = {
        disable-user-extensions = false;
        disabled-extensions = [ ];
        enabled-extensions = with pkgs.gnomeExtensions; [
          appindicator.extensionUuid
          alphabetical-app-grid.extensionUuid
          app-icons-taskbar.extensionUuid
          todotxt.extensionUuid
          battery-health-charging.extensionUuid
          bluetooth-battery-meter.extensionUuid
          caffeine.extensionUuid
          clipboard-indicator.extensionUuid
          dim-completed-calendar-events.extensionUuid
          do-not-disturb-while-screen-sharing-or-recording.extensionUuid
          gnome-40-ui-improvements.extensionUuid
          # fly-pie.extensionUuid
          just-perfection.extensionUuid
          launch-new-instance.extensionUuid
          # search-light.extensionUuid
          solaar-extension.extensionUuid
          middle-click-to-close-in-overview.extensionUuid
          night-theme-switcher.extensionUuid
          osd-volume-number.extensionUuid
          quick-settings-audio-panel.extensionUuid
          quick-touchpad-toggle.extensionUuid
          tailscale-qs.extensionUuid
          toggle-workspace-span.extensionUuid
          quick-web-search.extensionUuid
          unblank.extensionUuid
          user-themes.extensionUuid
          vitals.extensionUuid
        ];
        last-selected-power-profile = "balanced";
        remember-mount-password = true;
      };
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
        main-panel-height = mkTuple [
          false
          29
        ];
        middle-click-action = "QUIT";
        multi-window-indicator-style = "MULTI_DASH";
        notification-badges = false;
        panel-location = "TOP";
        panel-on-all-monitors = false;
        scroll-action = "NO_ACTION";
        show-apps-button = mkTuple [
          false
          0
        ];
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
      "org/gnome/shell/extensions/nightthemeswitcher/color-scheme" = {
        day = "prefer-light";
        night = "prefer-dark";
      };
      "org/gnome/shell/extensions/osd-volume-number" = {
        adapt-panel-menu = true;
        icon-position = "left";
        number-position = "right";
      };
      "org/gnome/shell/extensions/search-light" = {
        shortcut-search = [ "<Ctrl><Super>space" ];
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
        list-buttons = ''[{"name":"SystemItem","title":null,"visible":true},{"name":"OutputStreamSlider","title":null,"visible":true},{"name":"InputStreamSlider","title":null,"visible":false},{"name":"BrightnessItem","title":null,"visible":true},{"name":"NMWiredToggle","title":null,"visible":false},{"name":"NMWirelessToggle","title":"Wi-Fi","visible":true},{"name":"NMModemToggle","title":null,"visible":false},{"name":"NMBluetoothToggle","title":null,"visible":false},{"name":"NMVpnToggle","title":null,"visible":false},{"name":"BluetoothToggle","title":"Bluetooth","visible":true},{"name":"PowerProfilesToggle","title":"Power Mode","visible":true},{"name":"NightLightToggle","title":"Night Light","visible":true},{"name":"DarkModeToggle","title":"Dark Style","visible":true},{"name":"KeyboardBrightnessToggle","title":"Keyboard","visible":false},{"name":"RfkillToggle","title":"Airplane Mode","visible":true},{"name":"RotationToggle","title":"Auto Rotate","visible":true},{"name":"CaffeineToggle","title":"Caffeine","visible":true},{"name":"TailscaleMenuToggle","title":"Tailscale","visible":true},{"name":"FeatureToggle","title":"Touchpad","visible":true},{"name":"DndQuickToggle","title":"Do Not Disturb","visible":true},{"name":"BackgroundAppsToggle","title":"No Background Apps","visible":false},{"name":"MediaSection","title":null,"visible":false}]'';
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
      "org/gnome/shell/extensions/vitals" = {
        alphabetize = false;
        fixed-widths = true;
        hide-icons = false;
        hot-sensors = [
          "_fan_dell_ddv_cpu fan_"
          "_battery_rate_"
          "_processor_usage_"
        ];
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
    };
  };
}
