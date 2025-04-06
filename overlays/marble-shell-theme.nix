{ prev, ... }:
prev.marble-shell-theme.overrideAttrs (oldAttrs: {
  patches = [
    (builtins.toFile "disable-taskbar-icon-background" ''
      diff --git a/theme/gnome-shell/.css/panel.css b/theme/gnome-shell/.css/panel.css
      index 43b478b..6c67062 100644
      --- a/theme/gnome-shell/.css/panel.css
      +++ b/theme/gnome-shell/.css/panel.css
      @@ -36,6 +36,13 @@
           box-shadow: inset 0 0 0 1px BORDER-SHADOW;
       }

      +/* App icons taskbar - hide button background */
      +.panel-button.azTaskbar-BaseIcon {
      +    background-color: transparent !important;
      +    border: none !important;
      +    box-shadow: none !important;
      +}
      +
       .panel-button:hover,
       .panel-button:hover .clock,
       .panel-button:active,
    '')

    (builtins.toFile "fix-quick-settings-padding" ''
      diff --git a/theme/gnome-shell/.css/quick-settings.css b/theme/gnome-shell/.css/quick-settings.css
      index fcf8f86..e5f5c42 100644
      --- a/theme/gnome-shell/.css/quick-settings.css
      +++ b/theme/gnome-shell/.css/quick-settings.css
      @@ -2,7 +2,7 @@

       /* QS section */
       .quick-settings {
      -	padding: 15px;
      +	padding: 15px !important;
       	border-radius: 24px;
       }
    '')
  ];
})
