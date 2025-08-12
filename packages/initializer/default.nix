# this is for generating a home-manager flake for easy deployment
{ lib, nixpkgs, ... }:

let
    pkgs = lib.load nixpkgs;
in

pkgs.writeScriptBin "initializer" ''
    #!${pkgs.bash}/bin/bash
    INTERPRETER=${(pkgs.python312.withPackages (py: [
        pkgs.home-manager
        pkgs.nixos-rebuild
    ])).interpreter}
    FIXED_FILE=${pkgs.writeText "initializer.py" (pkgs.lib.replaceStrings ["home-manager switch" "home-manager-flake.nix" "nixos-flake.nix"] ["${pkgs.home-manager}/bin/home-manager switch" "${./home-manager-flake.nix}" "${./nixos-flake.nix}"] (builtins.readFile ./initializer.py))}
    $INTERPRETER $FIXED_FILE $@
''
