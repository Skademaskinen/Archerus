{pkgs, ...}:

{
    imports = [
        ../generic-laptop
        ./hardware-configuration.nix
        ./modules
    ];

    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users.mast3r = import ./home;

    services.displayManager.sessionPackages = [pkgs.swayfx];
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
    services.xserver.videoDrivers = [ "displaylink" "modesetting" ];

    virtualisation.vmVariant = {
        virtualisation.resolution = { x = 1920; y = 1080; };
        virtualisation.qemu.options = [
            "-device virtio-vga-gl"
            "-display gtk,gl=on"
        ];
    };

    environment.variables = {
        NIXOS_OZONE_WL = "1";
    };

    networking.hostName = "thinkpad";
    system.stateVersion = "24.11";


}
