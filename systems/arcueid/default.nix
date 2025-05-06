{pkgs, ...}:

{
    imports = [
        ../generic-desktop
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

    users.groups.input.members = ["mast3r"];

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
    services.xserver.videoDrivers = [ "amdgpu" "modesetting" ];

    environment.variables = {
        NIXOS_OZONE_WL = "1";
    };

    networking.hostName = "arcueid";
    system.stateVersion = "24.11";

    boot.swraid = {
        enable = true;
    };

}
