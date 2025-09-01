{ self, lib, nixpkgs, system, ... }:

let
    pkgs = lib.load nixpkgs;
in

config:

pkgs.writeScriptBin "nix-webserver" ''
    #!${pkgs.bash}/bin/bash
    ${self.packages.${system}.webserver}/bin/webserver --config ${pkgs.writeText "config.json" (builtins.toJSON config)} "$@"
''
