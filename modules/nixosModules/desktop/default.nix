inputs:

{ pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        firefox
        spotify
        discord
        vesktop
    ];

    services.xserver.enable = true;
    services.displayManager.sddm = {
        enable = true;
    };
    programs.hyprland.enable = true;
    programs.sway.enable = true;

    fonts.packages = with pkgs; [
        fira
        fira-mono
        nerdfonts
    ];
}
