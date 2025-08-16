{ lib, ... }:

let 
    mkWebProject = lib.mkWebProject;
in 

{ pkgs, config, lib, ... }:

let
    cfg = config.skade.projects.taoshi.website;
in

{
    options.skade.projects.taoshi.website = {
        port = lib.mkOption {
            type = lib.types.int;
            default = 8001;
            description = ''
                port to host taoshi website on
            '';
        };
    };

    config = mkWebProject config {
        name = "taoshi-web";
        subdomain = "taoshi";
        exec = "${pkgs.nodejs}/bin/node server.js ${builtins.toString cfg.port}";
        port = cfg.port;
        setup = ''
            if ! [ -f $proot ]; then
                cp ${pkgs.writeText "server.js" ''
                    const http = require('http');

                    const server = http.createServer((req, res) => {
                        res.writeHead(200, { 'Content-Type': 'text/plain' });
                        res.end('Hello World\n');
                    });

                    server.listen(${builtins.toString cfg.port}, () => {
                        console.log('Server running at http://localhost:${builtins.toString cfg.port}/');
                    });
                ''} $proot/server.js
            fi
        '';
    };
}
