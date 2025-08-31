{ lib, nixpkgs, ... }:

let
    pkgs = lib.load nixpkgs;
in

lib.mkWebServer {
    port = 8080;
    routes = {
        "/" = pkgs.writeText "index.html" "Hello, World!";
    };
    extra_files = {

    };
}
