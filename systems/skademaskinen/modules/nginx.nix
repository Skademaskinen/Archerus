{pkgs, config, lib, ...}: {

    services.nginx = let 
    sslCertificate = "${config.skademaskinen.storage}/ssl/${config.skademaskinen.domain}/domain.cert.pem";
        sslCertificateKey = "${config.skademaskinen.storage}/ssl/${config.skademaskinen.domain}/private.key.pem";
        makeProxy = path: location: if config.skademaskinen.test then {
            locations.${path} = {
    proxyPass = location;
                proxyWebsockets = true;
            };
        } else {
            inherit sslCertificate;
            inherit sslCertificateKey;
            forceSSL = true;
            locations.${path} = {
                proxyPass = location;
                proxyWebsockets = true;
            };
        };
        index = ''
            <script>
                function reroute(location){
                    window.location.href = "${if config.skademaskinen.test then ''http'' else ''https''}://"+location+"."+window.location.host
                }
            </script>
            <button onclick="reroute('jupyter')">Jupyter</button><br>
            <button onclick="reroute('nextcloud')">Nextcloud</button><br>
            <button onclick="reroute('api')">API</button><br>
            <button onclick="reroute('taoshi')">Taoshi website</button><br>
        '';
    in {
        enable = true;
        recommendedProxySettings = true;
        recommendedGzipSettings = true;
        recommendedTlsSettings = true;

        virtualHosts."document.${config.skademaskinen.domain}" = makeProxy "/" "http://localhost:8123";
        virtualHosts."jupyter.${config.skademaskinen.domain}" = makeProxy "/" "http://localhost:${builtins.toString config.services.jupyterhub.port}";
        virtualHosts."cloud.${config.skademaskinen.domain}" = makeProxy "/*" "http://localhost:${builtins.toString config.services.nextcloud.extraOptions.port}";
        virtualHosts."api.${config.skademaskinen.domain}" = makeProxy "/" "http://localhost:${builtins.toString config.skademaskinen.mast3r.website.port}";
        virtualHosts."taoshi.${config.skademaskinen.domain}" = makeProxy "/" "http://localhost:${builtins.toString config.skademaskinen.taoshi.website.port}";
        virtualHosts."${config.skademaskinen.domain}" = {
            inherit sslCertificate;
            inherit sslCertificateKey;
            forceSSL = true;
            locations."/".proxyPass = "http://localhost:${builtins.toString config.skademaskinen.F3.port}";
            
            locations."/.well-known/matrix/server".return = ''200 "{\"m.server\":\"matrix.skade.dev:443\"}"'';
            locations."/.well-known/matrix/client".return = ''200 "{\"m.homeserver\":{\"base_url\":\"https://matrix.skade.dev\"}}"'';
        };
        virtualHosts."matrix.${config.skademaskinen.domain}" = {
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

        };
        
    };
}
