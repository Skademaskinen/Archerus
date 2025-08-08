inputs:

{ lib, pkgs, ...}:

{
    options.skade = {
        projectsRoot = lib.mkOption {
            type = lib.types.str;
            default = "/mnt/raid";
        };
        baseDomain = lib.mkOption {
            type = lib.types.str;
            default = "localhost";
        };
    };
    config.virtualisation.vmVariant = {
        virtualisation.graphics = false;
    };
    
    # there is a high probability that we need nginx, so lets just configure it by default
    config.services.nginx = {
        enable = true;
        recommendedProxySettings = true;
        recommendedGzipSettings = true;
        recommendedTlsSettings = true;
    };

    # maintenance tools
    environment.systemPackages = with pkgs; [
        htop
    ];
}
