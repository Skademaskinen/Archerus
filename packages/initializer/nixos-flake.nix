{
    inputs.nixpkgs.url = "nixpkgs/nixos-25.05";
    inputs.archerus.url = "github:Skademaskinen/Archerus";
    inputs.archerus.inputs.nixpkgs.follows = "nixpkgs";
    outputs = inputs: {
        nixosConfigurations."host" = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = with inputs.archerus.nixosModules; [
                grub
                common
                desktop
                users.mast3r
            ];
        };
    };
}
