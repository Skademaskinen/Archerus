{pkgs, lib, config, ...}: 

let
        backend = pkgs.callPackage ../packages/backend.nix {};
in {
    options.skademaskinen.mast3r.website = {
        enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
        };
        root = lib.mkOption {
            type = lib.types.str;
        };
        databasePath = lib.mkOption {
            type = lib.types.str;
            default = "${config.skademaskinen.website.root}/webroot/admin/db.db3";
        };
        hostname = lib.mkOption {
            type = lib.types.str;
            default = "localhost";
        };
        port = lib.mkOption {
            type = lib.types.int;
            default = 12345;
        };
        keyfile = lib.mkOption {
            type = lib.types.str;
            default = pkgs.writeText "website-keyfile-temp" "temp-keyfile";
        };
    };

    config.systemd.services.backend = {
        enable = config.skademaskinen.mast3r.website.enable;
        description = "mast3r_waf1z website database server";
        environment = {
            SQLITE3_PATH = "${pkgs.sqlite-interactive}/bin/sqlite3";
            LSBLK_PATH = "${pkgs.util-linux}/bin/lsblk";
        };
        serviceConfig = if config.skademaskinen.mast3r.website.enable then {
            User = "mast3r";
            WorkingDirectory = config.skademaskinen.mast3r.website.root;
            ExecStart = "${pkgs.bash}/bin/bash ${backend}/bin/skademaskinen-backend -db ${config.skademaskinen.mast3r.website.databasePath} --hostname ${config.skademaskinen.mast3r.website.hostname} --port ${builtins.toString config.skademaskinen.mast3r.website.port} --keyfile ${config.skademaskinen.mast3r.website.keyfile}";
            Restart = "on-failure";
        } else {};
        wantedBy = ["default.target"];
    };
}