{pkgs, lib, config, ...}: let
    backend = pkgs.callPackage ../packages/backend { inherit config pkgs; };
in {
    options.skademaskinen.mast3r.backend = {
        enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
        };
        hostname = lib.mkOption {
            type = lib.types.str;
            default = "localhost";
        };
        port = lib.mkOption {
            type = lib.types.int;
            default = 12345;
        };
    };

    config.systemd.services.backend = {
        enable = config.skademaskinen.mast3r.backend.enable;
        description = "mast3r_waf1z website database server";
        environment = {
            SQLITE3_PATH = "${pkgs.sqlite-interactive}/bin/sqlite3";
            LSBLK_PATH = "${pkgs.util-linux}/bin/lsblk";
        };
        serviceConfig = if config.skademaskinen.mast3r.backend.enable then {
            User = "mast3r";
            WorkingDirectory = "${config.skademaskinen.storage}/website/backend";
            ExecStart = "${pkgs.bash}/bin/bash ${backend}/bin/skademaskinen-backend -db ${config.skademaskinen.storage}/website/backend/db.db3 --hostname ${config.skademaskinen.mast3r.backend.hostname} --port ${builtins.toString config.skademaskinen.mast3r.backend.port} --keyfile ${config.skademaskinen.storage}/website/backend/keyfile";
            Restart = "on-failure";
        } else {};
        wantedBy = ["default.target"];
        after = ["backend-setup.service"];
    };
    config.systemd.services.backend-setup = {
        enable = config.skademaskinen.mast3r.backend.enable;
        serviceConfig = {
            type = "oneshot";
            ExecStart = "${pkgs.bash}/bin/bash ${pkgs.writeScriptBin "backend-setup" ''
                mkdir -p ${config.skademaskinen.storage}/website/backend
                chown -R mast3r:wheel ${config.skademaskinen.storage}/website/backend
            ''}/bin/backend-setup";
        };
        wantedBy = ["default.target"];
    };
}