{
    description = "Skademaskinen configuration";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-23.11";
    };

    outputs = { self, nixpkgs }: 
    
    let
        system = "x86_64-linux";
        home-system = "aarch64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
        home-pkgs = nixpkgs.legacyPackages.${home-system};
    in {
        nixosConfigurations = {
            Skademaskinen = nixpkgs.lib.nixosSystem {
                inherit system;
                modules = [
                    ./systems/skademaskinen.nix
                ];
            };
            laptop = nixpkgs.lib.nixosSystem {
                inherit system;
                modules = [ 
                    ./systems/laptop.nix 
                ];
            };
            rpiZero2w = nixpkgs.lib.nixosSystem {
                system = home-system;
                modules = [ ./systems/rpi.nix ];
            };
        };

        devShells.home = home-pkgs.mkShell {
            system = home-system;
            buildInputs = [
                (home-pkgs.callPackage ./packages/backend.nix {})
            ];
        };
        packages.legacyPackages.${system} = {
            backend = pkgs.callPackage ./packages/backend.nix {};
            putricide = pkgs.callPackage ./packages/putricide.nix {};
            rp-utils = pkgs.callPackage ./packages/rp-utils.nix {};
        };
        packages.legacyPackages.${home-system} = {
            backend = pkgs.callPackage ./packages/backend.nix {};
        };
    };
}
