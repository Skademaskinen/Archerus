{pkgs, config, lib, ...}: let 
    doSSL = config.skademaskinen.domain != "localhost";
in {

    services.nginx = let 
    sslCertificate = "${config.skademaskinen.storage}/ssl/${config.skademaskinen.domain}/domain.cert.pem";
        sslCertificateKey = "${config.skademaskinen.storage}/ssl/${config.skademaskinen.domain}/private.key.pem";
        makeProxy = path: location: if doSSL then {
            inherit sslCertificate;
            inherit sslCertificateKey;
            forceSSL = true;
            locations.${path} = {
                proxyPass = location;
                proxyWebsockets = true;
            };
        } else {
            locations.${path} = {
                proxyPass = location;
                proxyWebsockets = true;
            };
        };
    in {
        enable = true;
        recommendedProxySettings = true;
        recommendedGzipSettings = true;
        recommendedTlsSettings = true;

        virtualHosts."document.${config.skademaskinen.domain}" = makeProxy "/" "http://localhost:8123";
        virtualHosts."jupyter.${config.skademaskinen.domain}" = makeProxy "/" "http://localhost:${builtins.toString config.services.jupyterhub.port}";
        virtualHosts."cloud.${config.skademaskinen.domain}" = makeProxy "/*" "http://localhost:${builtins.toString config.services.nextcloud.settings.port}";
        virtualHosts."api.${config.skademaskinen.domain}" = makeProxy "/" "http://localhost:${builtins.toString config.skademaskinen.mast3r.backend.port}";
        virtualHosts."taoshi.${config.skademaskinen.domain}" = makeProxy "/" "http://localhost:${builtins.toString config.skademaskinen.taoshi.website.port}";
        virtualHosts."${config.skademaskinen.domain}" = if doSSL then {
            inherit sslCertificate;
            inherit sslCertificateKey;
            forceSSL = true;
            locations."/".proxyPass = "http://localhost:${builtins.toString config.skademaskinen.mast3r.website.port}";
            
            locations."/.well-known/matrix/server".return = ''200 "{\"m.server\":\"matrix.skade.dev:443\"}"'';
            locations."/.well-known/matrix/client".return = ''200 "{\"m.homeserver\":{\"base_url\":\"https://matrix.skade.dev\"}}"'';
        } else {
            locations."/".proxyPass = "http://localhost:${builtins.toString config.skademaskinen.mast3r.website.port}";
            
            locations."/.well-known/matrix/server".return = ''200 "{\"m.server\":\"matrix.skade.dev:443\"}"'';
            locations."/.well-known/matrix/client".return = ''200 "{\"m.homeserver\":{\"base_url\":\"https://matrix.skade.dev\"}}"'';
        };
        virtualHosts."matrix.${config.skademaskinen.domain}" = if doSSL then {
            inherit sslCertificate;
            inherit sslCertificateKey;
            forceSSL = true;
            locations."/" = {
                proxyPass = "http://localhost:${builtins.toString config.skademaskinen.matrix.port}";
            };
            locations."/*" = {
                proxyPass = "http://localhost:${builtins.toString config.skademaskinen.matrix.port}";
            };
            locations."/.well-known/matrix/server".return = ''200 "{\"m.server\":\"matrix.skade.dev:443\"}"'';
            locations."/.well-known/matrix/client".return = ''200 "{\"m.homeserver\":{\"base_url\":\"https://matrix.skade.dev\"}}"'';
        } else {
            locations."/" = {
                proxyPass = "http://localhost:${builtins.toString config.skademaskinen.matrix.port}";
            };
            locations."/*" = {
                proxyPass = "http://localhost:${builtins.toString config.skademaskinen.matrix.port}";
            };
            locations."/.well-known/matrix/server".return = ''200 "{\"m.server\":\"matrix.skade.dev:443\"}"'';
            locations."/.well-known/matrix/client".return = ''200 "{\"m.homeserver\":{\"base_url\":\"https://matrix.skade.dev\"}}"'';
        };
        virtualHosts."map.${config.skademaskinen.domain}" = if doSSL then {
            inherit sslCertificate;
            inherit sslCertificateKey;
            forceSSL = true;
            locations."/".proxyPass = "http://localhost:25564";
        } else {
            locations."/".proxyPass = "http://localhost:25564";
        };
        
    };
}
