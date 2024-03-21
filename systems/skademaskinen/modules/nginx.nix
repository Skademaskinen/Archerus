{pkgs, config, lib, ...}: {

    services.nginx = let 
        sslCertificate = "/opt/SSL/domain.cert.pem";
        sslCertificateKey = "/opt/SSL/private.key.pem";
        makeProxy = path: location: {
            inherit sslCertificate;
            inherit sslCertificateKey;
            forceSSL = true;
            locations.${path}.proxyPass = location;
        };
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
        virtualHosts."${config.skademaskinen.domain}" = {
            inherit sslCertificate;
            inherit sslCertificateKey;
            forceSSL = true;
            default = true;
            root = "/.";
            locations."/".index = "${pkgs.writeText "index.html" ''
                <script>
                    function reroute(location){
                        window.location.href = "https://"+location+"."+window.location.host
                    }
                </script>
                <button onclick="reroute('jupyter')">Jupyter</button><br>
                <button onclick="reroute('nextcloud')">Nextcloud</button><br>
                <button onclick="reroute('mast3r')">Mast3r website</button><br>
                <button onclick="reroute('taoshi')">Taoshi website</button><br>
            ''}";
            locations."/admin".proxyPass = "http://localhost:${builtins.toString config.skademaskinen.mast3r.website.port}";
        };
    };
}
