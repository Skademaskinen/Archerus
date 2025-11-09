{ archerusPkgs, lib, ... }:

let
    archerusLib = lib;
in

{ pkgs, config, ... }:

{
    environment.systemPackages = with pkgs; [
        vimix-cursors
        feh
        (elegant-sddm.override {
            themeConfig.General.background = archerusLib.wallpapers.arcueid;
        })
        (sddm-astronaut.override {
            embeddedTheme = "pixel_sakura";
        })
    ];

    networking.networkmanager.enable = true;

    services.protonmail-bridge = {
        enable = true;
        path = with pkgs; [
            keepassxc
        ];
    };
    programs.thunderbird.enable = true;


    services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
        theme = "sddm-astronaut-theme";
        extraPackages = with pkgs; [
            kdePackages.qtmultimedia
            kdePackages.qtsvg
            kdePackages.qtvirtualkeyboard
        ];
    };

    programs.hyprland.enable = true;

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
