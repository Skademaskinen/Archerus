{ spicetify-nix, system, ...}:

let
    spice = spicetify-nix.legacyPackages.${system};
in

{
    imports = [
        spicetify-nix.homeManagerModules.default
    ];

    programs.spicetify = {
        enable = true;
        theme = spice.themes.lucid;
    };
}
