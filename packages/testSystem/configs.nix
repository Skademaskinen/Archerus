inputs:

{ config, pkgs, ... }:

{
    # general
    services.mysql = let
      cfg = config.services.homepage;
    in {
        enable = true;
        package = pkgs.mariadb;
        ensureUsers = [
            {
                name = cfg.db.user;
                ensurePermissions."${cfg.db.name}.*" = "ALL PRIVILEGES";
            }
            {
                name = "${cfg.db.user}@localhost";
                ensurePermissions."${cfg.db.name}.*" = "ALL PRIVILEGES";
            }
        ];
        ensureDatabases = [cfg.db.name];
    };

    # homepage
    services.homepage = {
        enable = true;
        port = 8080;
    };

}
