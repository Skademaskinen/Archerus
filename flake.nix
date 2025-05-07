{
    description = "Skademaskinen modules";

    inputs = {
        # external depends
        nixpkgs = {
            url = "nixpkgs/nixos-24.11";
        };
        nixos-hardware.url = "github:nixos/nixos-hardware";
        nixvim = {
            url = "github:nix-community/nixvim/nixos-24.11";
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

    outputs = inputs @ { self, nixpkgs, ...}:
    let
        system = "x86_64-linux";
        pkgs = import nixpkgs { inherit system; };
    in {
    };
}
