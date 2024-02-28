{ config, lib, pkgs, modulesPath, ... }: {
    services.nginx = {
        enable = true;
        recommendedProxySettings = true;
        recommendedGzipSettings = true;
        recommendedTlsSettings = true;
        #proxyResolveWhileRunning = true;
    
    
        virtualHosts.main = {
            forceSSL = true;
            reuseport = true;
            root = "/mnt/raid";
            locations."/jupyter" = {
                proxyPass = "http://localhost:30000";
                proxyWebsockets = true;
            };
            locations."/document" = {
                proxyPass = "http://localhost:8123";
            };
            locations."/nextcloud" = {
                proxyPass = "http://localhost:80";
                root = "/mnt/raid/webroot";
                proxyWebsockets = true;
                index = "index.php index.html /nextcloud/index.php";
            };
	            extraConfig = "rewrite ^(.*)/nextcloud/index\\.php(.*)$ $1 permanent;";
            locations."/" = {
                root="/mnt/raid/webroot";
            };
            locations."/admin" = {
                proxyPass = "http://localhost:12345";
            };
            sslCertificate = "/opt/SSL/domain.cert.pem";
            sslCertificateKey = "/opt/SSL/private.key.pem";
        };

    };
} 
