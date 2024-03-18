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
            laptop = nixpkgs-unstable.lib.nixosSystem {
                inherit system;
                modules = [ ./systems/laptop ./systems/laptop/modules/free.nix ];
            };
            laptop-proprietary = nixpkgs-unstable.lib.nixosSystem {
                inherit system;
                modules = [ ./systems/laptop ./systems/laptop/modules/proprietary.nix ];
            };
            desktop = nixpkgs-unstable.lib.nixosSystem {
                inherit system;
                modules = [ ./systems/desktop ];
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
