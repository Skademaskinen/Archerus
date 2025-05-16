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
        wayland.enable = true;
        wayland.compositor = "weston";
        theme = "elegant-sddm";
        extraPackages = [
            pkgs.elegant-sddm
        ];
    };
    programs.hyprland.enable = true;
    programs.sway.enable = true;

    fonts.packages = with pkgs; [
        fira
        fira-mono
        nerdfonts
    ];
}
