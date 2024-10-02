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
        # external depends
        nixpkgs.url = "nixpkgs/nixos-24.05";
        system-manager = {
            url = "github:numtide/system-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nix-system-graphics = {
            url = "github:soupglasses/nix-system-graphics";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        # personal project depends
        nix-velocity = {
            url = "github:Mast3rwaf1z/nix-velocity";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        homepage = {
            url = "github:Mast3rwaf1z/homepage";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, nix-velocity, homepage, system-manager, nix-system-graphics }: 
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
        nixosConfigurations.Skademaskinen = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = builtins.concatLists [defconfig [
                { 
                    _module.args = {
                        nix-velocity = nix-velocity;
                        homepage = homepage;
                    };
                }
                nix-velocity.nixosModules.default
                homepage.nixosModules.${system}.default
                ./systems/skademaskinen
                ./shared/bootloader/systemd-boot.nix
                ./shared/users/mast3r.nix
                ./shared/users/taoshi.nix
            ]];
        };

        # non-nixos systems
        systemConfigs = {
            default = system-manager.lib.makeSystemConfig {
                modules = [
                    nix-system-graphics.systemModules.default
                    ({
                        environment.systemPackages = [system-manager.packages.${system}.system-manager];
                        nixpkgs.hostPlatform = "x86_64-linux";
                        system-manager.allowAnyDistro = true;
                        system-graphics.enable = true;
                    })
                ];
            };
        };

        packages.${system} = {
            putricide = pkgs.callPackage ./packages/putricide {};
            rp-utils = pkgs.callPackage ./packages/rp-utils {};
            warcraftlogsuploader = pkgs.callPackage ./packages/warcraftlogsuploader {};
            banner = pkgs.callPackage ./packages/banner {};
            sketch-bot = pkgs.callPackage ./packages/sketch-bot {};
            lavalink = pkgs.callPackage ./packages/lavalink {};
            p8 = pkgs.callPackage ./packages/p8 {};
            server = nixosConfigurations.Skademaskinen.config.system.build.vm;
        };
    };
}
