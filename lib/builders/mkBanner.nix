{ nixpkgs, lib, ...}:

let
    pkgs = lib.load nixpkgs;
in

{ name, extraText ? "" }: let
in pkgs.stdenv.mkDerivation {
    name = "${name}-banner";
    version = "latest";
    src = null;
    dontUnpack = true;
    installPhase = ''
        ${pkgs.figlet}/bin/figlet "${name}" > $out
        echo "${extraText}" > $out
    '';
}

