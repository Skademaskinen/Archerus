{
    imports = [
        ./hardware-configuration.nix
        ./modules
    ];
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users.mast3r = import ./home;

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

    networking.hostName = "thinkpad";
    system.stateVersion = "24.11";

}
