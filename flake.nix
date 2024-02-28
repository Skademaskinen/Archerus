{
    description = "Skademaskinen configuration";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-23.11";
    };

    outputs = { self, nixpkgs }: 
    
    let
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
    in {
        nixosConfigurations = {
            Skademaskinen = nixpkgs.lib.nixosSystem {
                inherit system;
                modules = [
                    ./default.nix
                ];
            };
        };
    };
}
