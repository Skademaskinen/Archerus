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
    users.groups.input.members = ["mast3r"];

    services.displayManager.autoLogin.enable = true;
    services.displayManager.autoLogin.user = "mast3r";
    services.displayManager.defaultSession = "sway";

    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    services.fprintd.enable = true;

    hardware.pulseaudio.enable = false;
        security.rtkit.enable = true;
        services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
    };
    nixpkgs.config.allowUnfree = true;
    services.xserver.videoDrivers = [ "modesetting" ];

    virtualisation.vmVariant = {
        virtualisation.resolution = { x = 1920; y = 1080; };
        virtualisation.qemu.options = [
            "-device virtio-vga-gl"
            "-display gtk,gl=on"
        ];
    };

    networking.firewall = {
        allowedTCPPorts = [ 17171 22 3308 3306 3308 8080 5432 ];
    };
    environment.variables = {
        NIXOS_OZONE_WL = "1";
    };

    networking.hostName = "thinkpad";
    system.stateVersion = "24.11";


}
