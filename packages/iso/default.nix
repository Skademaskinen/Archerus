# this is my custom iso, just contains my preferred things for installing nixos
# this file will be built with my server and hosted on it as an endpoint on my API
# not only a nixos installer, but also my own personal arch linux installer

{ nixos-wizard, home-manager, self, nixpkgs, system, ... }:

let
    isoConfig = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
            (nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
            self.nixosModules.users.mast3r
            home-manager.nixosModules.default
            self.nixosModules.common
            ({ pkgs, lib, ... }: {
                environment.systemPackages = with pkgs; [
                    #nixos-wizard.packages.${system}.default
                    arch-install-scripts
                ];
                networking.networkmanager.enable = lib.mkForce false;
            })
        ];
    };
in isoConfig.config.system.build.isoImage
