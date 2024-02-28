{
    description = "Skademaskinen configuration";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    };

    outputs = { self, nixpkgs }: 
    
    let
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in {
    
        packages.x86_64-linux.skademaskinen-backend = pkgs.callPackage ./packages/backend.nix {};
    };
}
