{
    description = "Skademaskinen configuration";
    
    nixConfig = {
        extra-substituters = [
            "https://nix-community.cachix.org"
        ];
        extra-trusted-public-keys = [
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
    };

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-23.11";
        nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
        #home-manager.url = "github:nix-community/home-manager";
        #home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    outputs = { self, nixpkgs, nixpkgs-unstable, home-manager }: 
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
    in rec {
        nixosConfigurations = {
            Skademaskinen = nixpkgs.lib.nixosSystem {
                inherit system;
                modules = builtins.concatLists [defconfig [ 
                    ./systems/skademaskinen { skademaskinen.domain = "skade.dev"; }

                    ./shared/bootloader/systemd-boot.nix
                    ./shared/users/mast3r.nix
                    ./shared/users/taoshi.nix
                ]];
            };

            router = nixpkgs.lib.nixosSystem {
                inherit system;
                modules = builtins.concatLists [defconfig [
                    ./systems/router
                    ./shared/users/mast3r.nix
                ]];
            };
            laptop = nixpkgs-unstable.lib.nixosSystem {
                inherit system;
                modules = builtins.concatLists [defconfig [ 
                    ./systems/laptop 
                    ./systems/laptop/free.nix 

                    ./shared/bootloader/grub.nix
                    ./shared/programs/sway.nix
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

        packages.${system} = {
            backend = pkgs.callPackage ./packages/backend {};
            putricide = pkgs.callPackage ./packages/putricide {};
            rp-utils = pkgs.callPackage ./packages/rp-utils {};
            warcraftlogsuploader = pkgs.callPackage ./packages/warcraftlogsuploader {};
            banner = pkgs.callPackage ./packages/banner {};
            sketch-bot = pkgs.callPackage ./packages/sketch-bot {};
            lavalink = pkgs.callPackage ./packages/lavalink {};
            p8 = pkgs.callPackage ./packages/p8 {};
            skademaskinen = nixosConfigurations.Skademaskinen.config.system.build.vm;
        };
    };
}
