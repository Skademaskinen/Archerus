{ lib, nixpkgs, ... }:

let
    pkgs = lib.load nixpkgs;
in

{ id, sha256 }:

pkgs.stdenv.mkDerivation {
    name = "steam-fetch-${builtins.toString id}";
    nativeBuildInputs = [ pkgs.steamcmd ];

    outputHash = sha256;
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";

    buildCommand = ''
        mkdir -p $TMPDIR/{home,steam}
        export HOME="$TMPDIR/home"
        steamcmd +login anonymous \
                 +force_install_dir $TMPDIR/app \
                 +app_update ${builtins.toString id} validate \
                 +quit

        # Copy downloaded files to Nix store output
        cp -r $TMPDIR/app/* $out
    '';
}
