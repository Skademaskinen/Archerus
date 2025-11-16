{ pkgs, archerusPkgs, ... }: 

{
    wayland.windowManager.hyprland.extraConfig = ''
        monitor = eDP-1, 1920x1200, 0x0, 1
    '';
    wayland.windowManager.hyprland.settings = {
        exec-once = [
            "${pkgs.iio-hyprland}/bin/iio-hyprland"
            "${pkgs.wvkbd}/bin/wvkbd-mobintl -L 240 --hidden"
            "${pkgs.blueman}/bin/blueman-applet"
            
        ];
        plugin = {
            touch_gestures = {
                sensitivity = 10.0;
                workspace_swipe_fingers = 3;
                workspace_swipe_edge = "d";
                long_press_delay = 400;
                resize_on_border_long_press = true;
                edge_margin = 10;
                emulate_touchpad_swipe = true;

                hyprgrass-bind = [
                    ", edge:u:d, exec, ${archerusPkgs.nwg.drawer (builtins.readFile ../../modules/homeManagerModules/hyprland-themes/main/drawer.css)}"
                    ", edge:d:u, overview:toggle"
                    ", tap:2, exec, ${archerusPkgs.nwg.drawer (builtins.readFile ../../modules/homeManagerModules/hyprland-themes/main/drawer.css)}"
                    ", tap:3, exec, kill -34 $(ps -C wvkbd-mobintl)"
                    ", tap:4, killactive"
                    ", longpress:1, sendkeystate, , mouse:272, down, active"
                    ", edge:l:r, exec, ${archerusPkgs.nixLauncher}/bin/nix-launcher"
                ];
            };
        };
        gestures = {
            #workspace_swipe = true;
            workspace_swipe_cancel_ratio = 0.15;
        };
        decoration = {
            inactive_opacity = 0.99;
        };
    };
    # hyprgrass is a nice plugin that enables proper touchscreen support on hyprland
    wayland.windowManager.hyprland.plugins = with pkgs.hyprlandPlugins; [
        hyprgrass
        hyprspace
    ];


    home.file = {
        ".local/share/bolt-launcher/runelite.jar".source = "${pkgs.runelite}/share/RuneLite.jar";
    };

    home.packages = [
        pkgs.gimp3
        pkgs.krita
    ];

    skade.hyprland.terminal = {
        package = pkgs.kitty;
    };


    programs.fastfetch.settings.logo.source = archerusPkgs.lib.images.resize "256x256" archerusPkgs.lib.wallpapers.ciel;

    services.hyprpaper = {
        enable = true;
        settings = {
            preload = archerusPkgs.lib.wallpapers.ciel-big;
            wallpaper = ", ${archerusPkgs.lib.wallpapers.ciel-big}";
        };
    };
}
