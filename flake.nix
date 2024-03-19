{
    description = "Skademaskinen configuration";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-23.11";
        nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    };

    outputs = { self, nixpkgs, nixpkgs-unstable }: 
    let
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
        defconfig = [
            ./modules
            
            ./shared/locale.nix
            ./shared/networking.nix
            ./shared/programs/nix.nix
            ./shared/programs/git.nix
        ];
    in {
        nixosConfigurations = {
            Skademaskinen = nixpkgs.lib.nixosSystem {
                inherit system;
                modules = builtins.concatLists [defconfig [ 
                    ./systems/skademaskinen 

                    ./shared/bootloader/systemd-boot.nix
                    ./shared/users/mast3r.nix
                    ./shared/users/taoshi.nix
                ]];
            };
            laptop = nixpkgs-unstable.lib.nixosSystem {
                inherit system;
                modules = builtins.concatLists [defconfig [ 
                    ./systems/laptop 
                    ./systems/laptop/free.nix 

                    ./shared/bootloader/grub.nix
                    ./shared/programs/sway.nix
                    ./shared/users/mast3r.nix
                ]];
            };
            laptop-proprietary = nixpkgs-unstable.lib.nixosSystem {
                inherit system;
                modules = builtins.concatLists [defconfig [ 
                    ./systems/laptop 
                    ./systems/laptop/proprietary.nix 

                    ./shared/bootloader/grub.nix
                    ./shared/programs/plasma.nix
                    ./shared/users/mast3r.nix
                ]];
            };
            desktop = nixpkgs-unstable.lib.nixosSystem {
                inherit system;
                modules = builtins.concatLists [defconfig [ 
                    ./systems/desktop 

                    ./shared/bootloader/systemd-boot.nix
                    ./shared/programs/plasma.nix
                    ./shared/users/mast3r.nix
                ]];
            };
        };

        packages.legacyPackages.${system} = {
            backend = pkgs.callPackage ./packages/backend.nix {};
            putricide = pkgs.callPackage ./packages/putricide.nix {};
            rp-utils = pkgs.callPackage ./packages/rp-utils.nix {};
        };
    };
}
