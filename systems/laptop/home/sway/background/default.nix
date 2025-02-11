{pkgs, background}: let
    env = pkgs.python312.withPackages (py: with py; [
        pillow
        numpy
    ]);
in pkgs.stdenv.mkDerivation {
    name = "wallpaper.png";
    pname = "wallpaper.png";
    src = ./.;
    installPhase = ''
        ${env.interpreter} $src/rename.py ${background} ${pkgs.nixos-artwork.wallpapers.stripes-logo}/share/backgrounds/nixos/nix-wallpaper-stripes-logo.png $out
    '';
}
