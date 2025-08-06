inputs @ { self, nixpkgs, lib, system, ... }:



nixpkgs.lib.nixosSystem {
    inherit system;
    modules = with self; [
        inputs.home-manager.nixosModules.default
        nixosModules.common
        nixosModules.grub
        nixosModules.plymouth
        nixosModules.programming
        nixosModules.server.base
        nixosModules.server.dummyProject
        nixosModules.users.mast3r
        nixosModules.users.taoshi
        ({ pkgs, ... }:

        {
            imports = [
                ./hardware-configuration.nix
                ./packages.nix
            ];
            networking.hostName = lib.capitalize (builtins.baseNameOf ./.);
            system.stateVersion = "24.11";

            services.getty.autologinUser = "mast3r";
            nixpkgs.config.allowUnfree = true;

            programs.nix-ld.enable = true;
        })
    ];
}
