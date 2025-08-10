{ lib, ... }:

sysCfg: { name, subdomain ? name, secure ? sysCfg.skade.baseDomain != "localhost", port, ... } @ cfg: (lib.mkProject sysCfg cfg) // (let
    formattedName = if subdomain == "" then "" else "${subdomain}.";
in {
    services.nginx.virtualHosts."${formattedName}${sysCfg.skade.baseDomain}" = lib.mkProxy sysCfg {
        inherit secure;
        path = "/";
        location = "http://localhost:${builtins.toString port}";
    };

})
