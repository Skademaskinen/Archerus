{pkgs, config, ...}:

{
    imports = [
        ./hardware-configuration.nix
        ./modules
    ];

    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users.mast3r = import ./home;

    # quick hack to make swayfx understand it should run with proprietary nvidia drivers
    services.displayManager.sessionPackages = let
        swayfx-session = pkgs.stdenv.mkDerivation {
            pname = "swayfx";
            name = "swayfx";
            version = "latest";
            src = pkgs.swayfx;
            installPhase = ''
                mkdir -p $out/share/wayland-sessions
                sed "s/Exec=sway/Exec=sway --unsupported-gpu/g" $src/share/wayland-sessions/sway.desktop > $out/share/wayland-sessions/sway.desktop
            '';
            passthru.providedSessions = ["sway"];
        };
    in [swayfx-session];
    security.pam.services.swaylock = {};
    security.sudo.extraConfig = ''
        Defaults env_reset,pwfeedback
    '';

    services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
        wayland.compositor = "weston";
        theme = "breeze";
    };

    services.displayManager.autoLogin.enable = true;
    services.displayManager.autoLogin.user = "mast3r";
    services.displayManager.defaultSession = "sway";

    hardware.pulseaudio.enable = false;
        security.rtkit.enable = true;
        services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
    };
    nixpkgs.config.allowUnfree = true;

    networking.hostName = "laptop";
    system.stateVersion = "24.11";
}
