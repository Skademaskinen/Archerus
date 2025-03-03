{pkgs, lib, config, ...}: let
    background = import ./background { inherit pkgs; };
in {
    wayland.windowManager.sway = {
        enable = true;
        package = pkgs.swayfx;
        checkConfig = false;
        systemd.enable = true;
        xwayland = true;
        config = {
            bars = [];
            colors.focused = {
                border = "#ff5500";
                background = "#00000077";
                childBorder = "#ff5500";
                indicator = "#ff5500";
                text = "#ffffff";
            };
            colors.unfocused = {
                border = "#444444";
                background = "#00000077";
                childBorder = "#444444";
                indicator = "#ff5500";
                text = "#ffffff";
            };
            window.border = 1;
            window.titlebar = false;
            terminal = "${pkgs.alacritty}/bin/alacritty";
            gaps.inner = 3;
            gaps.outer = 3;
            modifier = "Mod4";
            menu = import ./nwg/drawer.nix { inherit pkgs; };
            input."type:keyboard" = {
                xkb_layout = "dk";
            };
            input."type:touchpad" = {
                dwt = "enabled";
                tap = "enabled";
                middle_emulation = "enabled";
            };

            output."*" = {
                bg = "${background} fill mode 1920x1200";
            };

            startup = [
                {
                    command = import ./nwg/panel.nix { inherit pkgs; };
                    always = true;
                }
                {
                    command = "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator";
                }
            ];

            defaultWorkspace = "workspace number 1";

            floating.criteria = [
                {
                    class = "feh";
                }
                {
                    class = "ffplay";
                }
            ];

            keybindings = let
                modifier = config.wayland.windowManager.sway.config.modifier;
            in lib.mkOptionDefault {
                "${modifier}+l" = ''exec swaylock --show-failed-attempts --ignore-empty-password -i ${background}'';
                "${modifier}+p" = ''exec ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp -d)" - | ${pkgs.wl-clipboard}/bin/wl-copy'';
                "${modifier}+n" = ''exec ${pkgs.swaynotificationcenter}/bin/swaync-client -t'';
                "${modifier}+b" = "border toggle";
                "Ctrl+Shift+Mod1+${modifier}+l" = "exec ${pkgs.xdg-utils}/bin/xdg-open https://linkedin.com";
                "XF86AudioMute" = ''exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_SINK@ toggle'';
                "XF86AudioRaiseVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume -l 1.0 @DEFAULT_SINK@ 5%+";
                "XF86AudioLowerVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume -l 1.0 @DEFAULT_SINK@ 5%-";
                "Mod4+Shift+XF86TouchpadOff" = "exec ${pkgs.alacritty}/bin/alacritty";
            };
        };
        extraConfig = ''
            workspace 1 output eDP-1
            workspace 2 output DP-5
            workspace 3 output eDP-1
            workspace 4 output DP-5
            workspace 5 output eDP-1
            workspace 6 output DP-5
            workspace 7 output eDP-1
            workspace 8 output DP-5
            workspace 9 output eDP-1
            workspace 10 output DP-5
            corner_radius 10
            for_window [title="^.*"] border pixel 1, title_format "<b> %class >> %title </b>"
        '';

    };
    home.packages = with pkgs; [
        foot
        gnome-themes-extra
        gopsuinfo
        grim
        gtklock
        gtklock-playerctl-module
        gtklock-powerbar-module
        gtklock-userinfo-module
        imagemagick
        jq
        libappindicator-gtk3
        networkmanagerapplet
        nwg-clipman
        nwg-displays
        nwg-dock
        nwg-drawer
        nwg-hello
        #nwg-icon-picker
        nwg-look
        nwg-menu
        nwg-panel
        #nwg-readme-browser
        #nwg-shell-config
        #nwg-shell-wallpapers
        papirus-icon-theme
        playerctl
        polkit_gnome
        slurp
        swappy
        swaybg
        swayidle
        swaylock
        swaynotificationcenter
        wl-clipboard
        wlsunset
        xdg-user-dirs
    ];

    programs.swaylock = {
        enable = true;

    };
    programs.swayr = {
        enable = true;
    };
    services.swayidle = {
        enable = true;
    };
    services.swaync = {
        enable = true;
        style = builtins.readFile ./swaync.css;
    };
    services.swayosd = {
        enable = true;
    };

    programs.rofi = {
        enable = true;
        package = pkgs.rofi-wayland;
        theme = "sidebar";
    };

}
