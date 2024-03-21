{pkgs}: pkgs.stdenv.mkDerivation rec {
    name = "lavalink";
    version = "4.0.4";
    pname = "lavalink";

    src = pkgs.fetchurl {
        url = "https://github.com/lavalink-devs/Lavalink/releases/download/${version}/Lavalink.jar";
        sha256 = "sha256-bfdzKJW5wUZmB9VNMg0rlVIOwp1qxEWKugic9fvz4Wc=";
    };
    dontUnpack = true;
    installPhase = ''
        mkdir -p $out/bin
        mkdir -p $out/share/lavalink
        cp $src $out/bin/lavalink
        echo "${builtins.readFile ../../files/lavalink.yml}" > $out/share/lavalink/application.yml
    '';
}