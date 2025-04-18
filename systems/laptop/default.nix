{pkgs, config, ...}:

{
    imports = [
        ../generic-desktop
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
                sed "s/Exec=sway/Exec=sway --unsupported-gpu -D noscanout/g" $src/share/wayland-sessions/sway.desktop > $out/share/wayland-sessions/sway.desktop
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
    services.xserver.enable = true;
    services.desktopManager.plasma6.enable = true;

    services.displayManager.autoLogin.enable = true;
    services.displayManager.autoLogin.user = "mast3r";
    services.displayManager.defaultSession = "sway";

    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    hardware.pulseaudio.enable = false;
        security.rtkit.enable = true;
        services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
    };
    nixpkgs.config.allowUnfree = true;

    virtualisation.vmVariant = {
        virtualisation.resolution = { x = 1920; y = 1080; };
        virtualisation.qemu.options = [
            "-device virtio-vga-gl"
            "-display gtk,gl=on"
        ];
    };

    boot.loader.grub.gfxmodeEfi = "1920x1080";

    networking.firewall = {
        allowedTCPPorts = [ 17171 22 3308 3306 ];
    };
    environment.variables = {
        NIXOS_OZONE_WL = "1";
    };

    programs.nix-ld.enable = true;

    services.mysql.enable = true;
    services.mysql.package = pkgs.mariadb;

    networking.hostName = "laptop";
    system.stateVersion = "24.11";
}
