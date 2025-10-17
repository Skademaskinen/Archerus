{ lib, archerusPkgs, ... }:

{ config, ... }:

let 
    drawer = lib.load ./drawer.nix;

    panelConfig = {
        drawer.command = drawer;
        battery.enable = config.skade.hyprland.battery.enable;
    };
in

{
    wayland.windowManager.hyprland.settings = {

        general = {
            "col.active_border" = "rgba(ff0000ff) rgba(ff0000ff)";
            "col.inactive_border" = "rgba(595959ff) rgba(595959ff)";
            "col.nogroup_border" = "rgba(595959ff) rgba(595959ff)";
            "col.nogroup_border_active" = "rgba(ff0000ff) rgba(ff0000ff)";
        };

        exec = [
            ((lib.load ./panel.nix) panelConfig)
        ];

        bind = [
            "$mod, d, exec, ${drawer}"
        ];
    };
    services.hyprpaper = {
        enable = true;
        settings = {
            preload = "${lib.wallpapers.fklub-padded-filled}";
            wallpaper = ", ${lib.wallpapers.fklub-padded-filled}";
        };
    };
    services.swaync = {
        enable = true;
        style = builtins.readFile ./swaync.css;
    };

    programs.fastfetch = {
        enable = true;
        settings = {
            logo = {
                source = archerusPkgs.lib.images.resize "256x256" archerusPkgs.lib.wallpapers.flogo-inverted;
            };
            modules = [
                "title"
                "os"
                "kernel"
                "uptime"
                "shell"
                {
                    "type" = "display";
                    "key" = "Resolution";
                    "compactType" = "original";
                }
                "wm"
                "wmtheme"
                {
                    "type" = "terminalfont";
                    "key" = "font";
                }
                "cpu"
                "gpu"
                {
                    "type" = "memory";
                    "key" = "RAM";
                    "percent" = {
                        "type" = 3;
                    };
                }
                {
                    "type" = "disk";
                    "folders" = "/";
                    "key" = "Disk";
                    "percent" = {
                        "type" = 3;
                    };
                }
            ];
        };
    };
}
