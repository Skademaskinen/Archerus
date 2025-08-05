inputs @ { self, nixpkgs, lib, system, ... }:



nixpkgs.lib.nixosSystem {
    inherit system;
    modules = with self; [
        inputs.home-manager.nixosModules.default
        nixosModules.common
        nixosModules.grub
        nixosModules.plymouth
        nixosModules.programming
        nixosModules.users.mast3r
        nixosModules.users.taoshi
        ({ pkgs, ... }:

        {
            imports = [
                ./hardware-configuration.nix
                ./packages.nix
            ];
            home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.mast3r.imports = [
                    homeManagerModules.neovim
                    homeManagerModules.zsh
                    { home.stateVersion = "24.11"; }
                ];

            };
            networking.hostName = lib.capitalize (builtins.baseNameOf ./.);
            system.stateVersion = "24.11";

            nixpkgs.config.allowUnfree = true;

            programs.nix-ld.enable = true;
        })
    ];
}
