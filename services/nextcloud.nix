{ config, lib, pkgs, modulesPath, ... }: {
    services.nextcloud = {
        enable = true;
        package = pkgs.nextcloud27;
        home = "/mnt/raid/webroot/nextcloud";
        hostName = "localhost";
        https = false;
        config = {
            adminpassFile = "/mnt/raid/webroot/nextcloud/adminpassFile";
        };
        extraOptions = {
            overwritewebroot = "/nextcloud";
            port = 80;
            overwritehost = "localhost";
            overwriteprotocol = "http";
            "overwrite.cli.url" = "http://localhost/nextcloud";
            loglevel = 0;
            "htaccess.RewriteBase" = "/nextcloud";
        };
        nginx.recommendedHttpHeaders = true;
    };

}
