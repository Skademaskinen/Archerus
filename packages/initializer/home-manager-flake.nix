{
    inputs = {
        nixpkgs.url = "nixpkgs/nixos-25.05";
        home-manager = {
            url = "github:nix-community/home-manager/release-25.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nixGL = {
            url = "github:nix-community/home-manager/nixGL";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        archerus = {
            url = "github:Skademaskinen/Archerus/work-ready-home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.home-manager.follows = "home-manager";
        };
    };

    outputs = { archerus, nixpkgs, home-manager, nixGL }: {
        homeConfigurations."user" = home-manager.lib.homeManagerConfiguration {
            modules = with archerus.homeManagerModules; [
                common
                hyprland
                sway
                kitty
                alacritty
                neovim
                zsh
                ({ pkgs, ... }: {  
                    home.username = name;
                    home.homeDirectory = "/home/${name}";
                    home.stateVersion = "25.05";
                    home.packages = [
                        pkgs.nixgl.nixGLIntel
                    ];
                })
            ];
            pkgs = import nixpkgs {
                system = "x86_64-linux";
                overlays = [ nixGL.overlay ];
            };
        };
    };
}
