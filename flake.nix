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
        nixpkgs = {
            url = "nixpkgs/nixos-24.11";
        };
        system-manager = {
            url = "github:numtide/system-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nix-system-graphics = {
            url = "github:soupglasses/nix-system-graphics";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        home-manager = {
            url = "github:nix-community/home-manager/release-24.11";
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
        folkevognen = {
            url = "github:Mast3rwaf1z/Folkevognen";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        putricide = {
            url = "github:Skademaskinen/Putricide";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        rp-utils = {
            url = "github:Skademaskinen/RP-Utils";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, system-manager, nix-system-graphics, home-manager, nix-velocity, homepage, putricide, rp-utils, folkevognen }: 
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
                    { 
                        _module.args = {
                            nix-velocity = nix-velocity;
                            homepage = homepage;
                        };
                    }
                    nix-velocity.nixosModules.default
                    homepage.nixosModules.${system}.default
                    putricide.nixosModules.default
                    rp-utils.nixosModules.default
                    ./systems/skademaskinen
                    ./shared/bootloader/systemd-boot.nix
                    ./shared/users/mast3r.nix
                    ./shared/users/taoshi.nix
                    {
                        # TODO: fix at some point
                        systemd.services.folkevognen = {
                            enable = true;
                            description = "Folkevognen";
                            wantedBy = [ "multi-user.target" ];
                            serviceConfig = {
                                WorkingDirectory = "/mnt/raid/folkevognen";
                                ExecStart = "${folkevognen.packages.${system}.default}/bin/folkevognen";
                                User = "mast3r";
                            };
                        };
                    }
                ]];
            };
            laptop = nixpkgs.lib.nixosSystem {
                inherit system;
                modules = builtins.concatLists [defconfig [
                    home-manager.nixosModules.home-manager
                    ./systems/laptop
                    ./shared/bootloader/grub.nix
                    ./shared/users/mast3r.nix
                ]];
            };
        };

        # non-nixos systems
        systemConfigs = {
            desktop = system-manager.lib.makeSystemConfig {
                modules = [
                    nix-system-graphics.systemModules.default
                    ({
                        environment.systemPackages = [system-manager.packages.${system}.system-manager];
                        nixpkgs.hostPlatform = system;
                        system-manager.allowAnyDistro = true;
                        system-graphics.enable = true;
                    })
                ];
            };
            laptop = system-manager.lib.makeSystemConfig {
                modules = [
                    nix-system-graphics.systemModules.default
                    ({
                        environment.systemPackages = [system-manager.packages.${system}.system-manager];
                        nixpkgs.hostPlatform = system;
                        system-manager.allowAnyDistro = true;
                        system-graphics = {
                            enable = true;
                        };
                    })
                ];
            };
        };

        packages.${system} = {
            warcraftlogsuploader = pkgs.callPackage ./packages/warcraftlogsuploader {};
            banner = pkgs.callPackage ./packages/banner {};
            sketch-bot = pkgs.callPackage ./packages/sketch-bot {};
            lavalink = pkgs.callPackage ./packages/lavalink {};
            p8 = pkgs.callPackage ./packages/p8 {};
            systems = builtins.mapAttrs (key: value: value.config.system.build.vm) self.nixosConfigurations;
            test-background = pkgs.callPackage ./systems/laptop/home/sway/background { inherit pkgs; background = ./files/wallpaper.png; };
        };
    };
}
