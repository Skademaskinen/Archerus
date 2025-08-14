{ lib, ... }:

let
    mkProxy = lib.mkProxy;
in

{ config, lib, ... }:

let
    secure = config.skade.baseDomain != "localhost";
in

{
    options.skade.projects.prometheus = {
        port = lib.mkOption {
            type = lib.types.int;
            default = 8090;
        };
    };
    config = {
        services.prometheus = {
            enable = true;
            port = config.skade.projects.prometheus.port;
            exporters = {
                node.enable = true;
                node.enabledCollectors = [ "systemd" ];
                systemd.enable = true;
            };
            globalConfig.scrape_interval = "10s"; # "1m"
            scrapeConfigs = map (name: {
                job_name = name;
                static_configs = [{
                    targets = [ "localhost:${toString config.services.prometheus.exporters.${name}.port}" ];
                }];
            }) [ "node" "systemd" ];
        };
        services.nginx.virtualHosts."prometheus.${config.skade.baseDomain}" = mkProxy config {
            inherit secure;
            path = "/";
            location = "http://localhost:${builtins.toString config.skade.projects.prometheus.port}";
        };
    };
}
