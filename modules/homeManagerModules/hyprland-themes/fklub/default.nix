{ lib, ... }:

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
}
