inputs:

sysCfg: { secure?false, location, path, extraLocations ? {}, ... }: let
    base = {
        forceSSL = secure;
        locations = {
            ${path} = {
                proxyPass = location;
                proxyWebsockets = true;
            };
        } // extraLocations;
    };
    sslCfg = {
        sslCertificate = "${sysCfg.skade.projectsRoot}/ssl/${sysCfg.skade.baseDomain}/domain.cert.pem";
        sslCertificateKey = "${sysCfg.skade.projectsRoot}/ssl/${sysCfg.skade.baseDomain}/private.key.pem";
    };
in (if secure then base // sslCfg else base)
