{pkgs, ...}: {
    imports = [./pipewire.nix];

    services.xserver.displayManager.defaultSession = "sway";
    services.xserver.desktopManager.plasma5.enable = true;

    programs.sway = {
        enable = true;
        extraPackages = with pkgs; [
            gtklock
            konsole
            dunst
            swaybg
            mvpaper
        ];
    };
}