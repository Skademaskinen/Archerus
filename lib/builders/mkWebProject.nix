{ lib, ... }:

sysCfg: cfg: (lib.mkProject sysCfg cfg) // (let
    name = lib.fIf cfg "subdomain" cfg.name;
    formattedName = if name == "" then "" else "${name}.";
in {
    services.nginx.virtualHosts."${formattedName}${sysCfg.skade.baseDomain}" = lib.mkProxy sysCfg {
        path = "/";
        location = "http://localhost:${builtins.toString cfg.port}";
        secure = lib.fIf cfg "secure" (sysCfg.skade.baseDomain != "localhost");
    };
})
