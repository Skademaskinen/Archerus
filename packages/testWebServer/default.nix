{ pkgs, lib, nixpkgs, ... }:

lib.mkWebServer {
    port = 8080;
    routes = {
        "/" = pkgs.writeText "index.html" "Hello, World!";
    };
    extra_files = {

    };
}
