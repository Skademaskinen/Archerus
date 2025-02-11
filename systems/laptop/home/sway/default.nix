{pkgs, lib, config, ...}:

{
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
                bg = "${import ./background { inherit pkgs; background = ../../../../files/wallpaper.png; }} fill mode 1920x1080";
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
                "${modifier}+l" = ''exec swaylock --show-failed-attempts --ignore-empty-password -i ~/Pictures/wallpaper.png'';
                "${modifier}+p" = ''exec ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp -d)" - | ${pkgs.wl-clipboard}/bin/wl-copy'';
                "${modifier}+n" = ''exec ${pkgs.swaynotificationcenter}/bin/swaync-client -t'';
                "${modifier}+b" = "border toggle";
                "Ctrl+Shift+Mod1+${modifier}+l" = "exec ${pkgs.xdg-utils}/bin/xdg-open https://linkedin.com";
                "XF86AudioMute" = ''exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_SINK@ toggle'';
                "XF86AudioRaiseVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume -l 1.0 @DEFAULT_SINK@ 5%+";
                "XF86AudioLowerVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume -l 1.0 @DEFAULT_SINK@ 5%-";
            };
        };
        extraConfig = ''
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
