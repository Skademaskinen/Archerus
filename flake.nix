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
        };

        devShells.home = home-pkgs.mkShell {
            system = home-system;
            buildInputs = [
                (home-pkgs.callPackage ./packages/backend.nix {})
            ];
        };
        packages.legacyPackages.${system}.backend = pkgs.callPackage ./packages/backend.nix {};
    };
}
