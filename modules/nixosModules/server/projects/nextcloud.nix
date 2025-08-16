{ lib, ...}:

let
    mkProxy = lib.mkProxy;
in

{ pkgs, config, lib, ...}:

{
    options.skade.projects.nextcloud.port = lib.mkOption {
        type = lib.types.int;
        default = 8089;
        description = ''
            port to host nextcloud on
        '';
    };
    config.services.nextcloud = {
        enable = true;
        package = pkgs.nextcloud31;
        home = "${config.skade.projectsRoot}/projects/nextcloud/home";
        hostName = "cloud.${config.skade.baseDomain}";
        https = config.skade.baseDomain != "localhost";
        config.adminpassFile = "${config.skade.projectsRoot}/projects/nextcloud/admin-password.txt";
        config.dbpassFile = "${config.skade.projectsRoot}/projects/nextcloud/admin-password.txt";
        config.dbtype = "mysql";
        database.createLocally = false;
        settings = {
            port = config.skade.projects.nextcloud.port;
            maintenance = false;
        };
        nginx.recommendedHttpHeaders = true;
        configureRedis = true;
        appstoreEnable = true;
    };
    config.systemd.services.nextcloud-setup.after = ["nextcloud-pre-setup.service"];
    config.systemd.services.nextcloud-pre-setup = {
        enable = true;
        wantedBy = [ "default.target" ];
        serviceConfig.ExecStart = "${pkgs.writeScriptBin "nextcloud-pre-setup" ''
            #!${pkgs.bash}/bin/bash
            if ! [ -f ${config.skade.projectsRoot}/projects/nextcloud/admin-password.txt ]; then
                echo "Creating admin password file for Nextcloud..."
                echo "mydefaultpassword" > ${config.skade.projectsRoot}/projects/nextcloud/admin-password.txt
            fi
        ''}/bin/nextcloud-pre-setup";
    };
    config.services.nginx.virtualHosts."cloud.${config.skade.baseDomain}" = mkProxy config {
        path = "/*";
        location = "http://localhost:${builtins.toString config.skade.projects.nextcloud.port}";
        secure = config.skade.baseDomain != "localhost";
    };
    config.skade.status.vhosts."nextcloud.${config.skade.baseDomain}".port = config.skade.projects.nextcloud.port;
}
