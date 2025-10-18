inputs @ { self, nixpkgs, lib, system, ... }:



nixpkgs.lib.nixosSystem {
    inherit system;
    modules = with self; [
        # Depends
        inputs.home-manager.nixosModules.default

        # System setup
        nixosModules.common
        nixosModules.systemd-boot
        nixosModules.plymouth
        nixosModules.users.mast3r

        # External projects
        nixosModules.server.mysql
        nixosModules.server.nextcloud
        nixosModules.server.matrix
        nixosModules.server.palworld
        nixosModules.server.prometheus

        # Hosted projects
        nixosModules.server.base
        nixosModules.server.homepage
        nixosModules.server.folkevognen
        nixosModules.server.putricide
        nixosModules.server.docs
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
