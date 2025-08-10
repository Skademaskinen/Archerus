inputs @ { self, ... }:

{
    imports = map (module: self.homeManagerModules.${module}) [
        "common"
        "neovim"
        "sway"
        "hyprland"
    ];
    home.stateVersion = "24.11";
}
