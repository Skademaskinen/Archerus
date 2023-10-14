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
      #root = "/opt/nginx";
      locations."/jupyter" = {
        proxyPass = "http://localhost:30000";
        proxyWebsockets = true;
      };
      locations."/" = {
        proxyPass = "http://localhost:80";
        #root = "/mnt/raid";
        #proxyWebsockets = true;
      };
      #locations."/nextcloud/.well-known/carddav" = {
      #  return = "301 $scheme://$host/remote.php/dav";
      #};
      #locations."/nextcloud/.well-known/caldav" = {
      #  return = "301 $scheme://$host/remote.php/dav";
      #};
      locations."home" = {
        root="/opt/nginx";
      };
      sslCertificate = "/opt/SSL/domain.cert.pem";
      sslCertificateKey = "/opt/SSL/private.key.pem";
    };
    
  };
}
