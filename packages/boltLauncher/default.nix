{ pkgs, ... }:

let
    pkg = pkgs.bolt-launcher;
in

pkgs.stdenv.mkDerivation {
    name = pkg.name;
    version = pkg.version;

    src = pkg;

    installPhase = ''
        mkdir -p $out/bin
        cp -r $src/share $out/share
        sed 's|exec "''${cmd\[@\]}"|exec "''${cmd[@]}" ''${NIXOS_OZONE_WL:+''${WAYLAND_DISPLAY:+--enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime=true}} "$@"|' $src/bin/bolt-launcher > $out/bin/bolt-launcher
        chmod +x $out/bin/bolt-launcher
    '';
}
