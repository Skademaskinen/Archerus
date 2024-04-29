{pkgs, config, lib, ...}: {

    services.nginx = let 
        sslCertificate = "/opt/SSL/domain.cert.pem";
        sslCertificateKey = "/opt/SSL/private.key.pem";
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
        virtualHosts."nextcloud.${config.skademaskinen.domain}" = makeProxy "/*" "http://localhost:${builtins.toString config.services.nextcloud.extraOptions.port}";
        virtualHosts."api.${config.skademaskinen.domain}" = makeProxy "/" "http://localhost:${builtins.toString config.skademaskinen.mast3r.website.port}";
        virtualHosts."taoshi.${config.skademaskinen.domain}" = makeProxy "/" "http://localhost:${builtins.toString config.skademaskinen.taoshi.website.port}";
        virtualHosts."matrix.${config.skademaskinen.domain}" = if config.skademaskinen.test then {
            locations."/" = {
                proxyPass = "http://localhost:${builtins.toString config.skademaskinen.matrix.port}";
                proxyWebsockets = true;
            };
            locations."/_matrix/" = {
                proxyPass = "http://localhost:${builtins.toString config.skademaskinen.matrix.port}";
                proxyWebsockets = true;
            };
        } else {
            inherit sslCertificate;
            inherit sslCertificateKey;
            forceSSL = true;
            locations."/" = {
                proxyPass = "http://localhost:${builtins.toString config.skademaskinen.matrix.port}";
                proxyWebsockets = true;
                extraConfig = ''
                    proxy_set_header Host $host;
                '';
            };
            locations."/_matrix/" = {
                proxyPass = "http://localhost:${builtins.toString config.skademaskinen.matrix.port}";
                proxyWebsockets = true;
                extraConfig = ''
                    proxy_set_header Host $host;
                '';
            };
        };
        virtualHosts."${config.skademaskinen.domain}" = if config.skademaskinen.test then {
            root = "/.";
            locations."/".index = "${pkgs.writeText "index.html" index}";
            locations."/admin".proxyPass = "http://localhost:${builtins.toString config.skademaskinen.mast3r.website.port}";
        } else {
            inherit sslCertificate;
            inherit sslCertificateKey;
            forceSSL = true;
            default = true;
            root = "/.";
            locations."/".index = "${pkgs.writeText "index.html" index}";
            locations."/admin".proxyPass = "http://localhost:${builtins.toString config.skademaskinen.mast3r.website.port}";
        };
    };
}
