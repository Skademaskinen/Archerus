{ lib, nixpkgs, ... }:

let
    pkgs = lib.load nixpkgs;
in

pkgs.stdenv.mkDerivation rec {
    name = "lavalink";
    version = "4.0.4";
    pname = "lavalink";

    src = pkgs.fetchurl {
        url = "https://github.com/lavalink-devs/Lavalink/releases/download/${version}/Lavalink.jar";
        sha256 = "sha256-bfdzKJW5wUZmB9VNMg0rlVIOwp1qxEWKugic9fvz4Wc=";
    };
    dontUnpack = true;
    installPhase = ''
        mkdir -p $out/{bin,share/${name},lib/${name}}
        cp $src $out/lib/${name}/${name}.jar
        echo "${builtins.toJSON {
            server = {
                port = 2333;
                address = "0.0.0.0";
            };

            spring.main.banner-mode = "log";

            lavalink.server = {
                password = "youshallnotpass";
                sources = {
                    youtube = true;
                    bandcamp = true;
                    soundcloud = true;
                    twitch = true;
                    vimeo = true;
                    mixer = true;
                    http = true;
                    local = false;
                };
                bufferDurationMs = 400;
                youtubePlaylistLoadLimit = 6;
                gc-warnings = true;
                noReplace = false;
            };

            metrics.prometheus = {
                enabled = false;
                endpoint = "/metrics";
            };

            sentry.dsn = "";

            logging = {
                file = {
                    max-history = 30;
                    max-size = "1GB";
                };
                path = "./logs/";
                level = {
                    root = "INFO";
                    lavalink = "INFO";
                };
            };
        }}" > $out/share/${name}/application.yml
        substitute ${pkgs.writeText name ''
            #!${pkgs.bash}/bin/bash
            set -e
            ${pkgs.jdk21}/bin/java -jar REPLACE_ME/lib/${name}/${name}.jar $@
        ''} $out/bin/${name} --replace-fail REPLACE_ME $out
        chmod +x $out/bin/${name}
    '';
}
