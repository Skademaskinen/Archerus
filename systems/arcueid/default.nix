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
        ({ pkgs, ... }:

        {
            imports = [
                ./hardware-configuration.nix
            ];
            home-manager.users.mast3r.imports = [
                homeManagerModules.common
                homeManagerModules.hyprland
                homeManagerModules.alacritty
                homeManagerModules.kitty
                homeManagerModules.spotify
                #homeManagerModules.sway
                ./home.nix
                (lib.load ./symlinks.nix)
            ];
            users.groups.input.members = ["mast3r"];
            services.displayManager.defaultSession = "hyprland";
            services.displayManager.autoLogin = {
                user = "mast3r";
                enable = true;
            };
            networking.hostName = lib.capitalize (builtins.baseNameOf ./.);
            networking.extraHosts = ''
                10.225.171.51 skade.dev
            '';
            system.stateVersion = "24.11";

            hardware.bluetooth.enable = true;
            services.blueman.enable = true;

            nixpkgs.config.allowUnfree = true;

            services.xserver.videoDrivers = [ "amdgpu" "modesetting" ];

            boot.swraid = {
                enable = true;
            };
            hardware.ckb-next.enable = true;
            services.hardware.openrgb = {
                enable = true;
                motherboard = "amd";
                package = pkgs.openrgb-with-all-plugins;
            };

            services.ollama = {
                enable = true;
                acceleration = "rocm";
                package = pkgs.ollama-rocm;
            };
            nixpkgs.config.rocmSupport = true;
            nix.settings = {
                substituters = [ "https://nix-gaming.cachix.org" "https://cache.nixos.org/" ];
                trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
                trusted-users = [ "root" "mast3r" ];
            };
            environment.systemPackages = [ pkgs.cachix ];

            programs.nix-ld.enable = true;

            programs.nix-ld.libraries = with pkgs; [
                libGL
            ];
        })
    ];
}
