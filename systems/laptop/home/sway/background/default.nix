{pkgs, background}: let
    env = pkgs.python312.withPackages (py: with py; [
        pillow
    ]);
in pkgs.stdenv.mkDerivation {
    name = "wallpaper.png";
    pname = "wallpaper.png";
    src = ./.;
    installPhase = ''
        ${env.interpreter} $src/overlay.py ${background} ${pkgs.nixos-artwork.wallpapers.simple-dark-gray-bootloader}/share/backgrounds/nixos/nix-wallpaper-simple-dark-gray_bootloader.png $out
    '';
}
