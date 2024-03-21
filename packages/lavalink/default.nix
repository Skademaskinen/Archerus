{pkgs}: pkgs.stdenv.mkDerivation rec {
    name = "lavalink";
    version = "4.0.4";
    pname = "lavalink";

    src = pkgs.fetchurl {
        url = "https://github.com/lavalink-devs/Lavalink/releases/download/${version}/Lavalink.jar";
        sha256 = "sha256-bfdzKJW5wUZmB9VNMg0rlVIOwp1qxEWKugic9fvz4Wc=";
    };
    dontUnpack = true;
    installPhase = ''cp -r $src $out'';
}