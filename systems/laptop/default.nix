{pkgs, config, ...}:

{
    imports = [
        ./hardware-configuration.nix
    ];

    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users.mast3r = import ./home;

    hardware.pulseaudio.enable = false;
        security.rtkit.enable = true;
        services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
    };
    nixpkgs.config.allowUnfree = true;

    programs.neovim.enable = true;
    environment.systemPackages = with pkgs; [
        neovim
        alacritty
        cargo
        python3
        unzip
        nodejs
        discord
        spotify
        kdePackages.breeze-gtk
        kdePackages.breeze-icons
        gtk3
        gobject-introspection

    ];
    fonts.packages = with pkgs; [
        fira
        fira-mono
    ];

    hardware.graphics = {
        enable = true;
    };

    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = false;
        powerManagement.finegrained = false;
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        prime.intelBusId = "PCI:0:2:0";
        prime.nvidiaBusId = "PCI:1:0:0";
        prime.sync.enable = true;
    };

    networking.hostName = "laptop";
    system.stateVersion = "24.11";
}
