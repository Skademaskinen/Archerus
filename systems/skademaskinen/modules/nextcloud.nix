{pkgs, lib, config, ...}: {
    options.skademaskinen.nextcloud.port = lib.mkOption {
        type = lib.types.int;
        default = 80;
    };
    config.services.nextcloud = {
        enable = true;
        package = pkgs.nextcloud29;
        home = "${config.skademaskinen.storage}/nextcloud";
        hostName = "cloud.${config.skademaskinen.domain}";
        https = !(config.skademaskinen.test);
        config.adminpassFile = "/etc/nextcloud-admin-password";
        settings = {
            port = config.skademaskinen.nextcloud.port;
            maintenance = false;
        };
        nginx.recommendedHttpHeaders = true;
        appstoreEnable = true;
    };
}
