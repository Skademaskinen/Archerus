inputs @ { self, nixpkgs, lib, system, ... }:



nixpkgs.lib.nixosSystem {
    inherit system;
    modules = with self; [
        inputs.home-manager.nixosModules.default
        inputs.nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen4
        inputs.nixos-hardware.nixosModules.lenovo-thinkpad
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
                ./packages.nix
                ./grub-hack.nix
            ];
            home-manager.users.mast3r.imports = [
                homeManagerModules.hyprland
                homeManagerModules.alacritty
                homeManagerModules.kitty
                homeManagerModules.sway
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

            services.fprintd.enable = true;

            nixpkgs.config.allowUnfree = true;
            services.ollama = {
                enable = true;
                acceleration = "rocm";
                package = pkgs.ollama-rocm;
            };
            nixpkgs.config.rocmSupport = true;
        })
    ];
}
