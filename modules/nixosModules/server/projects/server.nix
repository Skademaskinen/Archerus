{ self, lib, system, nixpkgs, home-manager, ... }:

let
    _lib = lib;
in

{ config, options, pkgs, lib, ... }:

let
    architectureDiagram = _lib.mkArchitecture {
        ports = config.networking.firewall.allowedTCPPorts;
        vhosts = config.skade.status.vhosts;
    };
    docs = (pkgs.nixosOptionsDoc { options = options.skade; }).optionsCommonMark;

    pages = {
        "index" = ''
            <!DOCTYPE HTML>
            <html style="text-align: center">
                <h1>Index</h1>
                ${builtins.concatStringsSep "\n" (map (page: "<a href=\"${page}.html\">${page}.html</a><br>") (builtins.attrNames pages))}
            </html>
        '';
        "arch" = ''
            <!DOCTYPE HTML>
            <html style="text-align: center">
                <h1>Architecture</h1>
                <img src="architecture-diagram.png">
            </html>
        '';
        "options" = ''
            <!DOCTYPE HTML>
            <html style="margin-left: 20%; margin-right: 20%">
                <section style="background-color: gray; padding: 1%;">
                    <h1>Options</h1>
                    ${builtins.readFile (pkgs.runCommand "options.html" {} ''
                        ${pkgs.cmark}/bin/cmark -t html ${docs} > $out
                    '')}
                </section>
            </html>
        '';
    };
    page_script = pkgs.writeScriptBin "page" ''
        #!${pkgs.bash}/bin/bash
        set -e
        cd $(dirname $0)/../workdir
        ${pkgs.python312}/bin/python -m http.server 8095
    '';
    page = pkgs.stdenv.mkDerivation {
        name = "page";
        version = "latest";
        src = null;
        dontUnpack = true;
        installPhase = ''
            mkdir -p $out/{bin,workdir}
            cp ${page_script}/bin/page $out/bin/page
            ${builtins.concatStringsSep "\n" (
                builtins.attrValues (
                    builtins.mapAttrs (name: html: "cp ${pkgs.writeText name html} $out/workdir/${name}.html") pages
                )
            )}
            cp ${architectureDiagram} $out/workdir/architecture-diagram.png
            cp ${docs} $out/workdir/docs.md

        '';
    };
in

{
    options.skade.status = {
        vhosts = lib.mkOption {
            type = lib.types.attrs;
            default = {};
            description = ''
                Attrset of data about a virtualhost
            '';
        };
    };
    config = _lib.mkWebProject config {
        name = "server";
        exec = "${page}/bin/page";
        port = 8095;
    };
}
