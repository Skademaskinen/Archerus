inputs:

{ pkgs, config, ... }:

{
    services.mysql.enable = true;
    services.mysql.dataDir = "${config.skade.projectsRoot}/projects/mysql";
    services.mysql.package = pkgs.mariadb;
    services.mysql.ensureUsers = [
        {
            name = config.skade.projects.homepage.db.user;
            ensurePermissions."${config.skade.projects.homepage.db.name}.*" = "ALL PRIVILEGES";
        }
        {
            name = "nextcloud";
            ensurePermissions."nextcloud.*" = "ALL PRIVILEGES";
        }
    ];
    services.mysql.ensureDatabases = ["homepage" "nextcloud"];

    systemd.services.mysql-setup = {
        enable = true;

        serviceConfig = {
            ExecStart = "${pkgs.writeScriptBin "mysql-setup" ''
                #!${pkgs.bash}/bin/bash
                mkdir -p ${config.services.mysql.dataDir}
                chown -R mysql:mysql ${config.services.mysql.dataDir}
            ''}/bin/mysql-setup";
        };
        before = ["mysql.service"];
        wantedBy = ["default.target"];
    };
}
