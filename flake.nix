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
        nixGL = {
            url = "github:nix-community/nixGL";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nix-gaming = {
            url = "github:fufexan/nix-gaming";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        home-manager = {
            url = "github:nix-community/home-manager/release-25.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        gradle2nix = {
            url = "github:tadfisher/gradle2nix/v2";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nyx = {
            url = "github:Peritia-System/Nyx-Tools";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nixos-wizard = {
            url = "github:km-clay/nixos-wizard";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        # non-flake files
        curseforge = {
            url = "https://curseforge.overwolf.com/downloads/curseforge-latest-linux.zip";
            flake = false;
        };
    };

    outputs = inputs:

    let
        system = "x86_64-linux";
        lib = import ./lib (inputs // { inherit system; });
    in 
    
    {
        inherit lib;
        homeManagerModules = lib.mkRecursiveModules ./modules/homeManagerModules;
        nixosModules = lib.mkRecursiveModules ./modules/nixosModules;
        packages.${system} = lib.mkRecursiveModules ./packages;
        nixosConfigurations = lib.mkRecursiveModules ./systems;
        homeConfigurations = lib.mkRecursiveModules ./systems/homes;
    };

}
