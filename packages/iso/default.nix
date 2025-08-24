# this is my custom iso, just contains my preferred things for installing nixos
# this file will be built with my server and hosted on it as an endpoint on my API
# not only a nixos installer, but also my own personal arch linux installer

{ lib, nixos-wizard, self, nixpkgs, system, ... }:

let
    isoConfig = nixpkgs.lib.nixosSystem {
        modules = [
            self.nixosModules.users.mast3r
            self.nixosModules.common
            ({ pkgs, ... }: {
                environment.systemPackages = with pkgs; [
                    nixos-wizard.packages.${system}.default
                    pkgs.arch-install-scripts
                ];
            })
        ];
    };
in isoConfig.config.system.build.isoImage
