{pkgs, config, lib, ...}: {

    services.nginx = let 
        listen = [{ addr = "localhost";} { addr = "*"; }]; 
        sslCertificate = "/opt/SSL/domain.cert.pem";
        sslCertificateKey = "/opt/SSL/private.key.pem";
        
    in {
        enable = true;
        recommendedProxySettings = true;
        recommendedGzipSettings = true;
        recommendedTlsSettings = true;

        virtualHosts."${config.skademaskinen.domain}" = {
            inherit listen;
            inherit sslCertificate;
            inherit sslCertificateKey;
            locations."/".index = "${pkgs.writeText "index.html" ''
                hi :)
            ''}";
        };
        virtualHosts."document.${config.skademaskinen.domain}" = {
            inherit listen;
            inherit sslCertificate;
            inherit sslCertificateKey;
            locations."/".proxyPass = "http://localhost:8123";
        };
        virtualHosts."jupyter.${config.skademaskinen.domain}" = {
            inherit listen;
            inherit sslCertificate;
            inherit sslCertificateKey;
            locations."/".proxyPass = "http://localhost:${builtins.toString config.services.jupyterhub.port}";
        };
        virtualHosts."nextcloud.${config.skademaskinen.domain}" = {
            inherit listen;
            inherit sslCertificate;
            inherit sslCertificateKey;
            locations."/".proxyPass = "http://localhost:${builtins.toString config.services.nextcloud.extraOptions.port}";
        };
        virtualHosts."website.${config.skademaskinen.domain}" = {
            inherit listen;
            inherit sslCertificate;
            inherit sslCertificateKey;
            locations."/".proxyPass = "http://localhost:${builtins.toString config.skademaskinen.website.port}";
        };      
        virtualHosts."taoshi.${config.skademaskinen.domain}" = {
            inherit listen;
            inherit sslCertificate;
            inherit sslCertificateKey;
            locations."/".proxyPass = "http://localhost:${builtins.toString config.skademaskinen.taoshi.website.port}";
        };
    };
}
