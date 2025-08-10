{ self, system, lib, ... }:

let
    dbInit = lib.database;
in

{ config, lib, pkgs, ...}:

let
    projectTools = self.packages.${system}.projectTools config;
    database = dbInit config;
in

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
        virtualisation.diskSize = 102400;
        virtualisation.memorySize = 16384;
        virtualisation.cores = 4;
    };
    
    # there is a high probability that we need nginx, so lets just configure it by default
    config.services.nginx = {
        enable = true;
        recommendedProxySettings = true;
        recommendedGzipSettings = true;
        recommendedTlsSettings = true;
    };
    config.networking.firewall.allowedTCPPorts = [ 80 443 22 ];
    config.virtualisation.vmVariant.virtualisation.forwardPorts = [
      { from = "host"; host.port = 8080; guest.port = 80; }
      { from = "host"; host.port = 2020; guest.port = 22; }
    
    ];

    # maintenance tools
    config.environment.systemPackages = with pkgs; [
        htop
        projectTools.secretHandler
        projectTools.reinit
        projectTools.getInitialized
    ];

    config.systemd.services.baseSetup = {
        enable = true;
        wantedBy = ["default.target"];
        serviceConfig.ExecStart = "${pkgs.writeScriptBin "baseSetup" ''
            #!${pkgs.bash}/bin/bash
            ${database.migrate}
        ''}/bin/baseSetup";
    };
}
