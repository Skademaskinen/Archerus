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
        ({ pkgs, ... }:

        {
            imports = [
                ./hardware-configuration.nix
            ];
            users.users.mast3r = {
                isNormalUser = true;
                hashedPassword = "$y$j9T$I5fyCjf3pYZTZjXYaPHtI/$88R1u4uNP6yCs8GCy5aXmyDVm7AVeyASoYOOuouh0k3";
                shell = pkgs.zsh;
                extraGroups = [ "wheel" "networkmanager" ];
            };
            programs.zsh.enable = true;
            users.groups.mast3r = {};
            home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.mast3r.imports = [
                    homeManagerModules.hyprland
                    homeManagerModules.nixvim
                    homeManagerModules.alacritty
                    homeManagerModules.kitty
                    homeManagerModules.sway
                    homeManagerModules.zsh
                    ./home.nix
                ];

            };
            users.groups.input.members = ["mast3r"];
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
        })
    ];
}
