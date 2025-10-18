{ lib, ...}:

let
    mkProxy = lib.mkProxy;
in

{ lib, config, ... }:

let
    cfg = config.skade.projects.matrix;
    location = "http://localhost:${builtins.toString config.skade.projects.matrix.port}";
    secure = config.skade.baseDomain != "localhost";
    protocol = if secure then "https" else "http";
    port = if secure then 443 else 80;

    # double calls to toJSON to escape the json string, as the string has to be escaped in the nginx config
    clientBody = builtins.toJSON (builtins.toJSON {
        "m.homeserver".base_url = "${protocol}://matrix.${config.skade.baseDomain}";
    });
    serverBody = builtins.toJSON (builtins.toJSON {
        "m.server" = "matrix.${config.skade.baseDomain}:${builtins.toString port}";
    });
in

{
    options.skade.projects.matrix = {
        port = lib.mkOption {
            type = lib.types.int;
            default = 6167;
            description = ''
                port to host matrix on
            '';
        };
    };

    config.services.matrix-conduit = {
        enable = true;
        settings.global.port = cfg.port;
        settings.global.server_name = "${config.skade.baseDomain}";
        settings.global.database_backend = "rocksdb";
        settings.global.allow_registration = false;
        settings.global.trusted_servers = ["matrix.org"];
    };
    config.services.nginx.virtualHosts."matrix.${config.skade.baseDomain}" = mkProxy config {
        inherit location secure;
        path = "/";
        extraLocations = {
            "/*".proxyPass = location;
            "/.well-known/matrix/client".return = ''200 ${clientBody}'';
            "/.well-known/matrix/server".return = ''200 ${serverBody}'';
        };
    };
    config.services.nginx.virtualHosts."${config.skade.baseDomain}".locations = {
        "/.well-known/matrix/client".return = ''200 ${clientBody}'';
        "/.well-known/matrix/server".return = ''200 ${serverBody}'';
    };

    config.skade.docs.vhosts."matrix.${config.skade.baseDomain}".port = config.skade.projects.matrix.port;
}
