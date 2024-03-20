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
            root = "/.";
            locations."/".index = "${pkgs.writeText "index.html" ''
                <a href="http://jupyter.${config.skademaskinen.domain}:${builtins.toString config.services.jupyterhub.port}">Jupyter</a><br>
                <a href="http://nextcloud.${config.skademaskinen.domain}:${builtins.toString config.services.jupyterhub.port}">Nextcloud</a><br>
                <a href="http://website.${config.skademaskinen.domain}:${builtins.toString config.skademaskinen.website.port}">Mast3r website</a><br>
                <a href="http://taoshi.${config.skademaskinen.domain}:${builtins.toString config.skademaskinen.taoshi.website.port}">Taoshi website</a><br>
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
