inputs:

{pkgs, lib, config, ...}: let
    wallpaper = pkgs.fetchurl inputs.self.lib.wallpapers.arcueid;
in {
    imports = [
        ./common/desktop.nix
    ];
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
            menu = import ./common/nwg/drawer.nix { inherit pkgs; };
            input."type:keyboard" = {
                xkb_layout = "dk";
            };

            output = {
                DP-3 = {
                    bg = "${wallpaper} fill mode 3840x2160";
                    scale = "2";
                    position = "0,0";
                    adaptive_sync = "on";
                };
                DP-1 = {
                    bg = "${wallpaper} fill mode 3840x2160";
                    scale = "2";
                    position = "1920,0";
                };
            };
            

            startup = [
                {
                    command = pkgs.callPackage ./common/nwg/panel.nix { };
                    always = true;
                }
                {
                    command = "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator";
                }
                {
                    command = "${pkgs.ckb-next}/bin/ckb-next -b";
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
                "${modifier}+Shift+q" = "exec echo";
                "Mod1+F4" = "kill";
                "${modifier}+l" = ''exec swaylock --show-failed-attempts --ignore-empty-password -i ${wallpaper}'';
                "XF86SelectiveScreenshot" = ''exec ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp -d)" - | ${pkgs.wl-clipboard}/bin/wl-copy'';
                "${modifier}+p" = ''exec ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp -d)" - | ${pkgs.wl-clipboard}/bin/wl-copy'';
                "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl s +5%";
                "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl s 5%-";
                "${modifier}+n" = ''exec ${pkgs.swaynotificationcenter}/bin/swaync-client -t'';
                "${modifier}+b" = "border toggle";
                "Ctrl+Shift+Mod1+${modifier}+l" = "exec ${pkgs.xdg-utils}/bin/xdg-open https://linkedin.com";
                "XF86AudioMute" = ''exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_SINK@ toggle'';
                "XF86AudioRaiseVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume -l 1.0 @DEFAULT_SINK@ 5%+";
                "XF86AudioLowerVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume -l 1.0 @DEFAULT_SINK@ 5%-";
            };
        };
        extraConfig = ''
            workspace 1 output DP-3
            workspace 2 output DP-1
            workspace 3 output DP-3
            workspace 4 output DP-1
            workspace 5 output DP-3
            workspace 6 output DP-1
            workspace 7 output DP-3
            workspace 8 output DP-1
            workspace 9 output DP-3
            workspace 10 output DP-1
            corner_radius 10
            for_window [title="^.*"] border pixel 1, title_format "<b> %class >> %title </b>"
        '';

    };
    home.packages = with pkgs; [
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
        wl-mirror
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
        style = builtins.readFile ./common/nwg/swaync.css;
    };
    services.swayosd = {
        enable = true;
    };
}
