inputs @ { self, ... }:

{
    imports = map (module: self.homeManagerModules.${module}) [
        "common"
        "nixvim"
        "sway"
        "hyprland"
        "programming"
    ];
    home.stateVersion = "24.11";
}
