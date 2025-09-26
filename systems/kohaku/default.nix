inputs @ { self, nixpkgs, lib, system, ... }:



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
                ./packages.nix
            ];
            home-manager.users.mast3r.imports = [
                homeManagerModules.common
                homeManagerModules.hyprland
                homeManagerModules.alacritty
                homeManagerModules.kitty
                homeManagerModules.spotify
                ./home.nix
            ];
            services.displayManager.defaultSession = "hyprland";
            services.displayManager.autoLogin = {
                user = "mast3r";
                enable = true;
            };
            networking.hostName = lib.capitalize (builtins.baseNameOf ./.);
            system.stateVersion = "24.11";

            hardware.bluetooth.enable = true;
            services.blueman.enable = true;

            nixpkgs.config.allowUnfree = true;

            programs.nix-ld.enable = true;
            hardware.nvidia = {
                package = config.boot.kernelPackages.nvidiaPackages.latest;
                open = false;
                prime = {
                    intelBusId = "PCI:0:2.0";
                    nvidiaBusId = "PCI:1:0:0";
                };
            };

            hardware.graphics.enable = true;

            services.xserver.videoDrivers = [ "nvidia" ];

        })
    ];
}
