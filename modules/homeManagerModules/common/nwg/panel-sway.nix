{pkgs, lib, config, ...}:

"${pkgs.nwg-panel}/bin/nwg-panel -c ${pkgs.writeText "panel.json" (lib.strings.toJSON [
  {
    brightness-slider = { };
    button-clipman = {
      command = "${pkgs.nwg-clipman}/bin/nwg-clipman";
      css-name = "button-custom";
      icon = "nwg-clipman";
      icon-size = 16;
      label = "";
      label-position = "right";
      tooltip = "Clipboard history [Alt]+c";
    };
    button-launcher = {
      command = "${pkgs.callPackage ./drawer.nix {}}";
      css-name = "button-custom";
      icon = "grid";
      icon-size = 16;
      label = "";
      label-position = "right";
      tooltip = "Application drawer [Alt]+F1";
    };
    clock = {
      css-name = "clock";
      format = "%a, %d. %b  %H:%M:%S";
      interval = 1;
      on-left-click = "";
      on-middle-click = "";
      on-right-click = "";
      on-scroll-down = "";
      on-scroll-up = "";
      root-css-name = "root-clock";
      tooltip-text = "";
    };
    controls = "right";
    controls-settings = {
      alignment = "right";
      backlight-controller = "brightnessctl";
      backlight-device = "";
      click-closes = true;
      commands = {
        bluetooth = "blueman-manager";
        net = "";
      } // (if config.desktop.battery then { "battery" = ""; } else {});
      components = [
        "brightness"
        "volume"
        "processes"
        "readme"
      ] ++ (if config.desktop.battery then ["battery"] else []);
      css-name = "controls-window";
      custom-items = [
        {
          cmd = "${pkgs.alacritty}/bin/alacritty} --working-directory /etc/nixos --command vim .";
          icon = "nix-snowflake-white";
          name = "Edit NixOS";
        }
        {
          cmd = "${pkgs.alacritty}/bin/alacritty} --command sudo nix-store --gc";
          icon = "nix-snowflake-white";
          name = "NixOS Garbage Collection";
        }
        {
          cmd = "${pkgs.alacritty}/bin/alacritty} --command sudo nix-store --optimize";
          icon = "nix-snowflake-white";
          name = "NixOS Store Optimize";
        }
        {
          cmd = "${pkgs.xdg-utils}/bin/xdg-open https://search.nixos.org/packages";
          icon = "search";
          name = "Search nixpkgs";
        }
        {
          cmd = "${pkgs.alacritty}/bin/alacritty} --working-directory /etc/nixos --command sh -c 'nix flake update && sudo nixos-rebuild switch'";
          icon = "nix-snowflake-white";
          name = "Update NixOS";
        }
        {
          cmd = "${pkgs.wl-mirror}/bin/wl-mirror DP-1";
          icon = "nwg-displays";
          name = "Mirror screen";
        }
        {
          cmd = "nwg-displays";
          icon = "nwg-displays";
          name = "Displays";
        }
      ];
      hover-opens = false;
      icon-size = 18;
      interval = 1;
      leave-closes = false;
      menu = {
        icon = "system-shutdown-symbolic";
        items = [
          {
            cmd = "nwg-lock";
            name = "Lock";
          }
          {
            cmd = ''${pkgs.sway}/bin/swaynag -t warning  -m "Exit sway?" -b "yes" "${pkgs.sway}/bin/swaymsg exit"'';
            name = "Exit sway session";
          }
          {
            cmd = ''${pkgs.sway}/bin/swaynag -t warning  -m "Reboot?" -b "yes" "reboot"'';
            name = "Restart";
          }
          {
            cmd = "nwg-dialog -p shutdown -c \"shutdown now\"";
            name = "Shutdown";
          }
        ];
        name = "Exit";
      };
      net-interface = "wlo1";
      output-switcher = true;
      root-css-name = "controls-overview";
      show-values = false;
      system-shutdown-symbolic = "system-shutdown";
      window-margin = 0;
      window-width = 320;
    };
    css-name = "panel-top";
    dwl-tags = {};
    exclusive-zone = true;
    height = 30;
    homogeneous = true;
    icons = "light";
    items-padding = 0;
    layer = "bottom";
    margin-bottom = 0;
    margin-top = 0;
    menu-start = "off";
    modules-center = [ "clock" ];
    modules-left = [
      "button-launcher"
      "playerctl"
    ];
    modules-right = [
      "sway-mode"
      "tray"
      "button-clipman"
    ];
    monitor = "";
    name = "top";
    openweather = {};
    output = "All";
    padding-horizontal = 0;
    padding-vertical = 0;
    playerctl = {
      button-css-name = "button-custom";
      buttons = true;
      buttons-position = "left";
      chars = 30;
      css-name = "button-grid";
      icon-size = 16;
      interval = 1;
      label-css-name = "panel-top";
    };
    position = "top";
    scratchpad = {};
    sigrt = 64;
    spacing = 2;
    sway-mode = {};
    sway-taskbar = {};
    sway-workspaces = {};
    swaync = {
      always-show-icon = true;
      css-name = "executor";
      icon-placement = "left";
      icon-size = 16;
      interval = 1;
      on-left-click = "${pkgs.swaynotificationcenter}/bin/swaync-client -t";
      on-middle-click = "";
      on-right-click = "";
      on-scroll-down = "";
      on-scroll-up = "";
      root-css-name = "root-executor";
      tooltip-text = "Notifications";
    };
    tray = {
      icon-size = 16;
      inner-css-name = "inner-tray";
      root-css-name = "tray";
      smooth-scrolling-threshold = 0;
    };
    use-sigrt = false;
    width = "auto";
  }
  {
    brightness-slider = {};
    clock = {};
    controls = "off";
    controls-settings = {};
    css-name = "panel-bottom";
    dwl-tags = {};
    exclusive-zone = true;
    executor-cpuav = {
      css-name = "";
      icon-placement = "right";
      icon-size = 16;
      interval = 2;
      on-left-click = "nwg-processes";
      on-middle-click = "";
      on-right-click = "";
      on-scroll-down = "";
      on-scroll-up = "";
      script = "${pkgs.gopsuinfo}/bin/gopsuinfo -i a";
      tooltip-text = "CPU average load";
    };
    executor-cpubar = {
      css-name = "";
      icon-placement = "left";
      icon-size = 16;
      interval = 2;
      on-left-click = "";
      on-middle-click = "";
      on-right-click = "";
      on-scroll-down = "";
      on-scroll-up = "";
      script = "${pkgs.gopsuinfo}/bin/gopsuinfo -c g";
      tooltip-text = "";
    };
    executor-drives = {
      css-name = "";
      icon-placement = "left";
      icon-size = 16;
      interval = 15;
      on-left-click = "";
      on-middle-click = "";
      on-right-click = "";
      on-scroll-down = "";
      on-scroll-up = "";
      script = "${pkgs.gopsuinfo}/bin/gopsuinfo -i n";
      tooltip-text = "";
    };
    executor-memory = {
      css-name = "";
      icon-placement = "left";
      icon-size = 16;
      interval = 5;
      on-left-click = "";
      on-middle-click = "";
      on-right-click = "";
      on-scroll-down = "";
      on-scroll-up = "";
      script = "${pkgs.gopsuinfo}/bin/gopsuinfo -i m";
      tooltip-text = "";
    };
    executor-temp = {
      css-name = "";
      icon-placement = "left";
      icon-size = 16;
      interval = 5;
      on-left-click = "";
      on-middle-click = "";
      on-right-click = "";
      on-scroll-down = "";
      on-scroll-up = "";
      script = "${pkgs.gopsuinfo}/bin/gopsuinfo -i t";
      tooltip-text = "";
    };
    height = 30;
    icons = "";
    items-padding = 0;
    layer = "bottom";
    margin-bottom = 0;
    margin-top = 0;
    menu-start = "off";
    menu-start-settings = {};
    modules-center = [ ];
    modules-left = [
      "sway-taskbar"
      "scratchpad"
    ];
    modules-right = [
      "executor-cpuav"
      "executor-cpubar"
      "executor-temp"
      "executor-memory"
      "executor-drives"
    ];
    monitor = "";
    name = "bottom";
    openweather = {};
    output = "All";
    padding-horizontal = 6;
    padding-vertical = 0;
    playerctl = {};
    position = "bottom";
    scratchpad = {
      angle = 0;
      css-name = "";
      icon-size = 16;
      single-output = false;
    };
    spacing = 10;
    sway-taskbar = {
      all-outputs = false;
      all-workspaces = true;
      image-size = 16;
      name-max-len = 15;
      show-app-icon = true;
      show-app-name = true;
      show-layout = true;
      task-padding = 0;
      workspace-buttons = false;
      workspace-menu = [
        "1"
        "2"
        "3"
        "4"
        "5"
        "6"
        "7"
        "8"
      ];
      workspaces-spacing = 0;
    };
    sway-workspaces = {};
    tray = {};
    width = "auto";
  }
])} -s ${./panel.css}"
