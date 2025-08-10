{pkgs, lib, config, ...}: {
    options.skademaskinen.nextcloud.port = lib.mkOption {
        type = lib.types.int;
        default = 80;
    };
    config = {
        services.nextcloud = {
            enable = true;
            package = pkgs.nextcloud31;
            home = "${config.skademaskinen.storage}/nextcloud-mysql";
            hostName = "cloud.${config.skademaskinen.domain}";
            https = !(config.skademaskinen.test);
            config.adminpassFile = "/etc/nextcloud-admin-password";
            config.dbpassFile = "/etc/nextcloud-admin-password";
            config.dbtype = "mysql";
            database.createLocally = false;
            settings = {
                port = config.skademaskinen.nextcloud.port;
                maintenance = false;
            };
            nginx.recommendedHttpHeaders = true;
            configureRedis = true;
            appstoreEnable = true;
            #caching = {
            #    redis = true;
            #    apcu = false;
            #};
            #settings = {
            #    "redis.host" = "localhost";
            #    "redis.port" = 6379;
            #    "memcache.local" = "\\OC\\Memcache\\Redis";
            #    "memcache.distributed" = "\\OC\\Memcache\\Redis";
            #    "memcache.locking" = "\\OC\\Memcache\\Redis";
            #};
        };
        #services.redis.servers.nextcloud = {
        #    enable = true;
        #    user = "nextcloud";
        #    unixSocket = "/run/redis-nextcloud/redis.sock";
        #    port = 6379;
        #};
    };
}
