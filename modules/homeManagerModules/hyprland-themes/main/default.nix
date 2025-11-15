{ pkgs, archerusPkgs, ... }:

{ config, lib, ... }:

let 
    drawer = archerusPkgs.lib.load ./drawer.nix;

    panelConfig = {
        drawer.command = drawer;
        battery.enable = config.skade.hyprland.battery.enable;
        terminal = config.skade.hyprland.terminal;
    };
in

{
    wayland.windowManager.hyprland.settings = {

        general = {
            "col.active_border" = "rgba(ff5500ff) rgba(ff5500ff)";
            "col.inactive_border" = "rgba(595959ff) rgba(595959ff)";
            "col.nogroup_border" = "rgba(595959ff) rgba(595959ff)";
            "col.nogroup_border_active" = "rgba(ff5500ff) rgba(ff5500ff)";
        };

        exec = [
            ((archerusPkgs.lib.load ./panel.nix) panelConfig)
        ];

        bind = [
            "$mod, d, exec, ${drawer}"
        ];
    };
    services.hyprpaper = {
        enable = true;
        settings = {
            preload = lib.mkDefault "${archerusPkgs.lib.wallpapers.arcueid}";
            wallpaper = lib.mkDefault ", ${archerusPkgs.lib.wallpapers.arcueid}";
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
                source = lib.mkDefault (archerusPkgs.lib.images.resize "256x256" archerusPkgs.lib.wallpapers.kohaku);
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
    
    home.packages = with pkgs; [
        nwg-displays
    ];

}
