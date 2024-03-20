{pkgs, lib, config, ...}: {
    options.skademaskinen.nextcloud.port = lib.mkOption {
        type = lib.types.int;
        default = 80;
    };
    config.services.nextcloud = {
        enable = true;
        package = pkgs.nextcloud27;
        home = "${config.skademaskinen.storage}/nextcloud";
        hostName = "nextcloud.${config.skademaskinen.domain}";
        https = false;
        config.adminpassFile = "${config.skademaskinen.storage}/nextcloud/adminpassFile";
        extraOptions = {
            port = config.skademaskinen.nextcloud.port;
        };
        nginx.recommendedHttpHeaders = true;
    };
}
