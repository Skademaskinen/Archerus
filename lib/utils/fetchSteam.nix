{ lib, nixpkgs, ... }:

let
    pkgs = lib.load nixpkgs;
in

{ id, sha256 }:

# WIP, the hash is not necessarily the same
pkgs.stdenv.mkDerivation {
    name = "steam-fetch-${builtins.toString id}";
    nativeBuildInputs = [ pkgs.steamcmd ];

    outputHash = sha256;
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";

    buildCommand = ''
        mkdir -p $TMPDIR/{home,steam}
        export HOME="$TMPDIR/home"
        steamcmd +force_install_dir $TMPDIR/app \
            +login anonymous \
            +app_update ${builtins.toString id} validate \
            +quit

        mkdir -p $out
        # Copy downloaded files to Nix store output
        cp -r $TMPDIR/app/* $out
    '';
}
