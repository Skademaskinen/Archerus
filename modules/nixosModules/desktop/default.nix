inputs:

{ pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        firefox
        spotify
        discord
        vesktop
        vimix-cursors
    ];

    networking.networkmanager.enable = true;

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
        fira-mono
        nerd-fonts.droid-sans-mono
	nerd-fonts.fira-code
    ];

    services.pulseaudio.enable = false;
        security.rtkit.enable = true;
        services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
    };

    environment.variables = {
        NIXOS_OZONE_WL = "1";
    };

}
