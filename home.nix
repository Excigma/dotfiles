{ config, pkgs, ... }:

{
  home = {
    username = "excigma";
    homeDirectory = "/home/excigma";

    # link the configuration file in current directory to the specified location in home directory
    file = {
      ".p10k.zsh".source = ./.config/.p10k.zsh;
      "face.jpg".source = ./.local/share/backgrounds/Profile.jpg;
      ".local" = {
        source = ./.local;
        recursive = true;
      };
      ".config" = {
        source = ./.config;
        recursive = true;
      };
    };
  };

  qt.enable = true;
  qt.platformTheme.name = "gtk3";

  programs.git = {
    enable = true;
    userName = "Excigma";
    userEmail = "git@excigma.xyz";
  };

  programs.zsh = {
    enable = true;
    initExtraFirst = ''
      # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
      # Initialization code that may require console input (password prompts, [y/n]
      # confirmations, etc.) must go above this block; everything else may go below.
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
    shellAliases = {
      ".." = "cd ..";
      "grep" = "grep --color=auto";
      "diff" = "diff --color=auto";
      "neofetch" = "fastfetch --load-config neofetch";
      "ls" = "eza --all --git --icons";
    };
    history = {
      size = 10000;
      append = true;
      ignoreAllDups = true;
      extended = false;
      share = true;
    };
  };

  programs.zsh.defaultKeymap = "emacs";
  programs.zsh.initExtra = ''
    zstyle ':autocomplete:history-search-backward:*' list-lines 1000

    ZLE_RPROMPT_INDENT=0
    ZSH_AUTOSUGGEST_USE_ASYNC=true
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
    ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=40

    # Ctrl + Backspace/Delete to delete word
    bindkey '^H' backward-kill-word
    bindkey "^[[3;5~" kill-word

    # Delete to delete
    bindkey "^[[3~" delete-char

    # Ctrl + ArrowLeft / ArrowRight to move cursor
    bindkey "^[[1;5C" forward-word
    bindkey "^[[1;5D" backward-word

    # Home/End keys
    bindkey '^[[H' beginning-of-line
    bindkey '^[[F' end-of-line

    zstyle ':autocomplete:*' min-input 3
    zstyle ':autocomplete:*' delay 0.1
  '';

  programs.zoxide.enable = true;
  programs.zoxide.enableZshIntegration = true;
  programs.zoxide.options = [ "--cmd cd" ];

  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = { theme = "dark:dark-theme,light:light-theme"; };
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs.gnomeExtensions; [
    (pkgs.marble-shell-theme.override { colors = [ "blue" ]; })

    appindicator
    alphabetical-app-grid
    app-icons-taskbar
    battery-health-charging
    bluetooth-battery-meter
    caffeine
    clipboard-indicator
    dim-completed-calendar-events
    do-not-disturb-while-screen-sharing-or-recording
    native-window-placement
    launch-new-instance
    gnome-40-ui-improvements
    just-perfection
    middle-click-to-close-in-overview
    night-theme-switcher
    osd-volume-number
    quick-settings-tweaker
    quick-settings-audio-panel
    quick-touchpad-toggle
    tailscale-qs
    toggle-workspace-span
    user-themes
    vitals
  ];

  dconf = {
    enable = true;
    settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = with pkgs.gnomeExtensions; [
          # Put UUIDs of extensions that you want to enable here.
          # If the extension you want to enable is packaged in nixpkgs,
          # you can easily get its UUID by accessing its extensionUuid
          # field (look at the following example).
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

          # Alternatively, you can manually pass UUID as a string.
          # "blur-my-shell@aunetx"
          # ...
        ];
      };

      # # Configure individual extensions
      # "org/gnome/shell/extensions/blur-my-shell" = {
      #   brightness = 0.75;
      #   noise-amount = 0;
      # };

      "org/gnome/desktop/background" = {
        color-shading-type = "solid";
        picture-options = "zoom";
        picture-uri = "file://${config.home.homeDirectory}/.local/share/backgrounds/SolidDesert-Light.png";
        picture-uri-dark = "file://${config.home.homeDirectory}/.local/share/backgrounds/SolidDesert-Dark.png";
      };
    };
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
