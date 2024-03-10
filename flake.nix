{
    description = "Skademaskinen configuration";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-23.11";
        nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    };

    outputs = { self, nixpkgs, nixpkgs-unstable }: 
    let
        system = "x86_64-linux";
        home-system = "aarch64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
        home-pkgs = nixpkgs.legacyPackages.${home-system};
    in {
        nixosConfigurations = {
            Skademaskinen = nixpkgs.lib.nixosSystem {
                inherit system;
                modules = [ ./systems/skademaskinen ];
            };
            laptop = nixpkgs.lib.nixosSystem {
                inherit system;
                modules = [ ./systems/laptop ];
            };
            desktop = nixpkgs-unstable.lib.nixosSystem {
                inherit system;
                modules = [ ./systems/desktop ];
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
    };
}
