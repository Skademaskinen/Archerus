# this is for generating a home-manager flake for easy deployment
{ lib, nixpkgs, ... }:

let
    pkgs = lib.load nixpkgs;
    hyprland_desktop = pkgs.writeText (pkgs.lib.replaceString "Hyprland" "nixGLIntel Hyprland" (builtins.readFile "${pkgs.hyprland}/share/wayland-sessions/hyprland.desktop"));
    sway_desktop = pkgs.writeText "sway.desktop" (pkgs.lib.replaceString "sway" "nixGLIntel sway" (builtins.readFile "${pkgs.sway-unwrapped}/share/wayland-sessions/sway.desktop"));
    source_strings = ["home-manager-executable" "home-manager-flake.nix" "nixos-flake.nix" "hyprland.desktop" "sway.desktop"];
    target_strings = [ "${pkgs.home-manager}/bin/home-manager" "${./home-manager-flake.nix}" "${./nixos-flake.nix}" "${hyprland_desktop}" "${sway_desktop}"];
in

pkgs.writeScriptBin "initializer" ''
    #!${pkgs.bash}/bin/bash
    INTERPRETER=${(pkgs.python312.withPackages (py: [
        pkgs.home-manager
        pkgs.nixos-rebuild
    ])).interpreter}
    FIXED_FILE=${pkgs.writeText "initializer.py" (pkgs.lib.replaceStrings source_strings target_strings (builtins.readFile ./initializer.py))}
    $INTERPRETER $FIXED_FILE $@
''
