inputs:

{ pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        firefox
    ];

    networking.networkmanager.enable = true;

    services.xserver.enable = true;
    services.displayManager.sddm = {
        enable = true;
    };
    programs.hyprland.enable = true;
    programs.sway.enable = true;
}
