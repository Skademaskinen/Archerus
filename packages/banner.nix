{pkgs ? import <nixpkgs> {}, name ? "test", ...}: pkgs.stdenv.mkDerivation {
    name = "banner";
    pname = "banner";
    src = null;
    dontUnpack = true;
    installPhase = ''
        ${pkgs.figlet}/bin/figlet "${name}" > $out
    '';
}
