{ pkgs, archerusPkgs, ... }: 

{
    wayland.windowManager.hyprland.extraConfig = ''
        monitor = eDP-1, 1920x1200, 0x0, 1
    '';
    wayland.windowManager.hyprland.settings = {
        exec-once = [
            "${pkgs.iio-hyprland}/bin/iio-hyprland"
            "${pkgs.wvkbd}/bin/wvkbd-mobintl"
        ];
        plugin = {
            touch_gestures = {
                sensitivity = 4.0;
                workspace_swipe_fingers = 3;
                workspace_swipe_edge = "d";
                long_press_delay = 400;
                resize_on_border_long_press = true;
                edge_margin = 10;
                emulate_touchpad_swipe = true;

                hyprgrass-bind = [
                    ", edge:u:d, exec, ${archerusPkgs.nwg.drawer (builtins.readFile ../../modules/homeManagerModules/hyprland-themes/main/drawer.css)} "
                    ", edge:d:u, exec, kill -34 $(ps -C wvkbd-mobintl)"
                    ", tap:4, killactive"
                    ", longpress:1, sendkeystate, , mouse:272, down, active"
                ];
            };
        };
    };
    # hyprgrass is a nice plugin that enables proper touchscreen support on hyprland
    wayland.windowManager.hyprland.plugins = [
        pkgs.hyprlandPlugins.hyprgrass
    ];


    home.file = {
        ".local/share/bolt-launcher/runelite.jar".source = "${pkgs.runelite}/share/RuneLite.jar";
    };
}
