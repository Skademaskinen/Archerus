{ lib, system, self, archerusPkgs, ... }:

let
    _lib = lib;
in

{ config, options, pkgs, lib, ... }:

let
    htmlFile = pkgs.writeText "index.html";
    architectureDiagram = _lib.mkArchitecture {
        ports = config.networking.firewall.allowedTCPPorts;
        vhosts = config.skade.docs.vhosts;
        format = "png";
    };
    docs = _lib.mkOptionsHtml (options.skade);
    webserver = _lib.mkWebServer rec {
        routes = {
            "/" = htmlFile ''
                <!DOCTYPE HTML>
                <html style="text-align: center">
                    <h1>Index</h1>
                    ${builtins.concatStringsSep "\n" (map (page: "<a href=\"${page}\">${page}</a><br>") (builtins.attrNames routes))}
                </html>
            '';
            "/Architecture" = htmlFile ''
                <!DOCTYPE HTML>
                <html style="text-align: center">
                    <h1>Architecture</h1>
                    <img src="architecture-diagram.png">
                </html>
            '';
            "/Options" = htmlFile docs;
            "/fklub" = htmlFile ''
                <!DOCTYPE HTML>
                <html>
                    <h1>F-NixOS</h1>
                    <a href="F-NixOS.iso">F-NixOS ISO image</a>
                </html>
            '';
        };
        port = 8095;
        extra_files = {
            "/architecture-diagram.png" = {
                path = architectureDiagram;
                type = "image/png";
            };
            "/F-NixOS.iso" = {
                path = "${archerusPkgs.fIso}/iso/${archerusPkgs.fIso.isoName}";
                type = "application/x-iso9660-image";
            };
        };
    };
in

{
    options.skade.docs = {
        vhosts = lib.mkOption {
            type = lib.types.attrs;
            default = {};
            description = ''
                Attrset of data about a virtualhost
            '';
        };
    };
    config = _lib.mkWebProject config {
        name = "docs";
        exec = "${webserver}/bin/nix-webserver";
        port = 8095;
    };
}
