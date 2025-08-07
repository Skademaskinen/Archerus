{
    description = "Skademaskinen modules";

    inputs = {
        # external depends
        nixpkgs = {
            url = "nixpkgs/nixos-25.05";
        };
        nixos-hardware.url = "github:nixos/nixos-hardware";
        nixvim = {
            url = "github:nix-community/nixvim/nixos-25.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        home-manager = {
            url = "github:nix-community/home-manager/release-25.05";
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
        
        # Binaries
        curseforge = {
            url = "https://curseforge.overwolf.com/downloads/curseforge-latest-linux.zip";
            flake = false;
        };
    };

    outputs = _inputs: let
        inputs = _inputs // {
            system = "x86_64-linux"; lib = import ./lib (_inputs // { system = "x86_64-linux"; });
        };
    in 
    
    {
        homeManagerModules = import ./modules/homeManagerModules inputs;
        nixosModules = import ./modules/nixosModules inputs;
        packages = import ./packages inputs 
            // inputs.lib;
        nixosConfigurations = import ./systems inputs;
        lib = inputs.lib;
    };

}
