{pkgs, config, lib, ...}: let
    cfg = "config.skademaskinen.p8";
in {
    options.skademaskinen.p8 = {
        enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
        };
        port = lib.mkOption {
            type = lib.types.int;
            default = 8800;
        };
        path = lib.mkOption {
            type = lib.types.str;
            default = "${config.skademaskinen.storage}/p8/prod/Backend";
        };
        test = {
            enable = lib.mkOption {
                type = lib.types.bool;
                default = false;
            };
            port = lib.mkOption {
                type = lib.types.int;
                default = 8801;
            };
            path = lib.mkOption {
                type = lib.types.str;
                default = "${config.skademaskinen.storage}/p8/test/Backend";
            };
        };
    };

    config = let
        env = pkgs.python311.withPackages (py: with py; [
            transformers
            pytorch
        ]);
    in {
        systemd.services.p8-prod = if config.skademaskinen.p8.enable then {
            enable = config.skademaskinen.p8.enable;
            path = with pkgs; [bash env];
            serviceConfig = {
                WorkingDirectory = config.skademaskinen.p8.path;
                User = "root";
                ExecStart = "${pkgs.bash}/bin/bash -c '${config.skademaskinen.p8.path}/build/bin/backend -p ${builtins.toString config.skademaskinen.p8.port}' -L ${config.skademaskinen.storage}/p8/prod.log";
                Restart = "on-failure";
            };
            wantedBy = ["default.target"];
            after = ["network-online.target"];
            wants = ["network-online.target"];
        } else {};
        systemd.services.p8-test = if config.skademaskinen.p8.test.enable then {
            enable = config.skademaskinen.p8.test.enable;
            path = with pkgs; [bash env];
            serviceConfig = {
                WorkingDirectory = config.skademaskinen.p8.test.path;
                User = "root";
                ExecStart = "${pkgs.bash}/bin/bash -c '${config.skademaskinen.p8.test.path}/build/bin/backend -vvvvvvv -p ${builtins.toString config.skademaskinen.p8.test.port}'";
                Restart = "on-failure";
            };
            wantedBy = ["default.target"];
            after = ["network-online.target"];
            wants = ["network-online.target"];
        } else {};

        # Updating timers

        systemd.timers.p8-prod-update = if config.skademaskinen.p8.enable then {
            enable = config.skademaskinen.p8.enable;
            wantedBy = ["timers.target"];
            timerConfig = {
                OnBootSec = "5m";
                OnUnitActiveSec = "1d";
                Unit = "p8-prod-update.service";
            };
        } else {};
        systemd.services.p8-prod-update = if config.skademaskinen.p8.enable then {
            enable = config.skademaskinen.p8.enable;
            script = ''
                cd ${config.skademaskinen.p8.path}
                systemctl stop p8-prod.service
                ${pkgs.su}/bin/su mast3r -c '${pkgs.git}/bin/git pull'
                ${pkgs.cmake}/bin/cmake -B build
                ${pkgs.cmake}/bin/cmake --build build
                systemctl start p8-prod.service
            '';
            serviceConfig = {
                Type = "oneshot";
                User = "root";
            };
        } else {};

        systemd.timers.p8-test-update = if config.skademaskinen.p8.test.enable then {
            enable = config.skademaskinen.p8.test.enable;
            wantedBy = ["timers.target"];
            timerConfig = {
                OnBootSec = "5m";
                OnUnitActiveSec = "1d";
                Unit = "p8-test-update.service";
            };
        } else {};

        systemd.services.p8-test-update = if config.skademaskinen.p8.test.enable then {
            enable = config.skademaskinen.p8.test.enable;
            script = ''
                cd ${config.skademaskinen.p8.test.path}
                systemctl stop p8-test.service
                ${pkgs.su}/bin/su mast3r -c '${pkgs.git}/bin/git pull'
                ${pkgs.cmake}/bin/cmake -B build
                ${pkgs.cmake}/bin/cmake --build build
                systemctl start p8-test.service
            '';
            serviceConfig = {
                Type = "oneshot";
                User = "root";
            };
        } else {};
    };
}
