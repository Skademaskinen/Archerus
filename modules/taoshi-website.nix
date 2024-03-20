{pkgs, config, lib, ...}: {
    options.skademaskinen.taoshi.website = {
        enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
        };

        port = lib.mkOption {
            type = lib.types.int;
            default = 8001;
        };
    };

    config.systemd.services.taoshi-website = if config.skademaskinen.taoshi.website.enable then {
        enable = config.skademaskinen.taoshi.website.enable;
        serviceConfig = {
            WorkingDirectory = "${config.users.users.taoshi.home}/Nodejs";
            ExecStart = "${pkgs.nodejs}/bin/node server.js";
            User = "taoshi";
        };
        wantedBy = [ "default.target" ];
    } else {};
}
