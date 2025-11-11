inputs @ { self, nixpkgs, archerusPkgs, lib, system, ... }:

# This is a custom build lenovo thinkpad l13 gen 6 AMD 2-in-1 variant
# Getting this half-tablet to work well will be fun!

nixpkgs.lib.nixosSystem {
    inherit system;
    modules = with self; [
        inputs.home-manager.nixosModules.default
        nixosModules.common
        nixosModules.desktop
        nixosModules.gaming
        nixosModules.grub
        nixosModules.plymouth
        nixosModules.programming
        nixosModules.users.mast3r
        ({ pkgs, config, ... }:

        {
            imports = [
                ./hardware-configuration.nix
                inputs.nixos-hardware.nixosModules.lenovo-thinkpad
            ];
            home-manager.users.mast3r.imports = [
                homeManagerModules.common
                homeManagerModules.hyprland
                homeManagerModules.hyprland-themes.main
                homeManagerModules.alacritty
                homeManagerModules.kitty
                homeManagerModules.spotify
                (lib.load ./home.nix)
            ];
            services.displayManager.defaultSession = "hyprland";
            services.displayManager.autoLogin = {
                #user = "mast3r";
                #enable = true;
            };
            networking.hostName = lib.capitalize (builtins.baseNameOf ./.);
            system.stateVersion = "25.11";

            services.fprintd.enable = true;

            hardware.bluetooth.enable = true;
            services.blueman.enable = true;

            nixpkgs.config.allowUnfree = true;

            programs.nix-ld.enable = true;

            hardware.graphics.enable = true;

            environment.systemPackages = [
                archerusPkgs.electronApps.chatgpt
                archerusPkgs.electronApps.youtube
                archerusPkgs.electronApps.stregsystemet
                archerusPkgs.electronApps.fikien
                archerusPkgs.electronApps.nixosSearch
                archerusPkgs.electronApps.pathbuilder
                pkgs.vesktop
                pkgs.firefox
                pkgs.discord
            ];

            programs.iio-hyprland.enable = true;
            hardware.sensor.iio.enable = true;
        })
    ];
}
