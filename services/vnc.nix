{ config, lib, pkgs, modulesPath, ... }: {
    services.xserver.enable = true;
    services.xserver.displayManager.lightdm.enable = true;
    services.xserver.windowManager.i3.enable = true;

    services.xrdp.enable = true;
    services.xrdp.defaultWindowManager = "i3";
    services.xrdp.openFirewall = true;
    services.xserver.displayManager.lightdm.greeters.gtk.iconTheme = {
        package = pkgs.libsForQt5.breeze-gtk;
        name = "Breeze-gtk";
    };
}
