{ archerusPkgs, ... }:

{ pkgs, config, ... }:

{
    environment.systemPackages = with pkgs; [
        vimix-cursors
        feh
    ];

    networking.networkmanager.enable = true;

    services.protonmail-bridge = {
        enable = true;
        path = with pkgs; [
            keepassxc
        ];
    };
    programs.thunderbird.enable = true;

    services.displayManager.cosmic-greeter = {
        enable = true;

    };
    #services.xserver.enable = true;
    #services.displayManager.sddm = {
    #    enable = true;
    #    wayland.enable = true;
    #    wayland.compositor = "weston";
    #    theme = "elegant-sddm";
    #    extraPackages = [
    #        pkgs.elegant-sddm
    #    ];
    #};
    programs.hyprland.enable = true;
    programs.sway.enable = true;

    fonts.packages = with pkgs; [
        archerusPkgs.comicMonoLiga
        fira-mono
        nerd-fonts.droid-sans-mono
	    nerd-fonts.fira-code
        fira-code-symbols
        noto-fonts-color-emoji
        noto-fonts
        liberation_ttf
        mplus-outline-fonts.githubRelease
        dina-font
        proggyfonts
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
