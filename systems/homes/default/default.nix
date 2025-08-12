{ home-manager, self, lib, nixpkgs, ... }:

name:

home-manager.lib.homeManagerConfiguration {
    modules = with self.homeManagerModules; [
        common
        hyprland
        sway
        kitty
        alacritty
        neovim
        zsh
        {  
            home.username = name;
            home.homeDirectory = "/home/${name}";
            home.stateVersion = "25.05";
        }
    ];
    pkgs = lib.load nixpkgs;
}
