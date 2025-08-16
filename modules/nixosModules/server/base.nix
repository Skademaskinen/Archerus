{ self, system, lib, ... }:

let
    dbInit = lib.database;
    setIf = lib.setIf;
    strIf = lib.strIf;
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
            description = ''
                Root directory for hosting projects
            '';
        };
        baseDomain = lib.mkOption {
            type = lib.types.str;
            default = "skade.dev";
            description = ''
                base domain for the server, this will determine SSL and routing settings
            '';
        };
        wireguard = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = ''
                Whether to enable wireguard connection
            '';
        };
    };
    config = {
        virtualisation.vmVariant = {
            virtualisation.graphics = false;
            virtualisation.diskSize = 102400;
            virtualisation.memorySize = 16384;
            virtualisation.cores = 4;

            virtualisation.forwardPorts = [
                { from = "host"; host.port = 8080; guest.port = 80; }
                { from = "host"; host.port = 2020; guest.port = 22; }
            ];

            skade.wireguard = false;
            skade.baseDomain = "localhost";
            skade.projectsRoot = "/vmVariant";
            skade.projects.homepage = {
                db.dialect = "sqlite";
            };
        };
        skade.type = "server";
        
        # there is a high probability that we need nginx, so lets just configure it by default
        services.nginx = {
            enable = true;
            recommendedProxySettings = true;
            recommendedGzipSettings = true;
            recommendedTlsSettings = true;
        };
        networking.firewall.allowedTCPPorts = [ 80 443 22 ];

        # maintenance tools
        environment.systemPackages = with pkgs; [
            htop
            git
            projectTools.secretHandler
            projectTools.reinit
            projectTools.getInitialized
        ];

        systemd.services.baseSetup = {
            enable = true;
            wantedBy = ["default.target"];
            serviceConfig.ExecStart = "${pkgs.writeScriptBin "baseSetup" ''
                #!${pkgs.bash}/bin/bash
                ${database.migrate}

                ${strIf config.skade.wireguard ''
                    mkdir -p ${config.skade.projectsRoot}/vpn
                    touch ${config.skade.projectsRoot}/vpn/client.key
                ''}
            ''}/bin/baseSetup";
        };
        
        systemd.timers.dailyRestart = {
            enable = true;
            wantedBy = [ "timers.target" ];
            timerConfig = {
                OnCalendar = "*-*-* 05:00:00";
                Persistent = true;
            };  
        };
        systemd.services.dailyRestart = {
            enable = true;
            serviceConfig = {
                ExecStart = "${pkgs.writeScriptBin "dailyRestart" ''
                    #!${pkgs.bash}/bin/bash
                    echo "Restarting every service!"
                    for project in ${database.getAllProjects}; do
                        echo "Restarting $project"
                        systemctl restart $project.service
                    done
                    echo "Restarted every service"
                ''}/bin/dailyRestart";
                Type = "oneshot";
            };
        };

        networking.wireguard.interfaces = setIf config.skade.wireguard {
            wg0 = {
                ips = ["10.200.200.2/32"];
                listenPort = 51820;
                privateKeyFile = "${config.skade.projectsRoot}/vpn/client.key";
                peers = [{
                    publicKey = "fOPhWd+No02Doi2hvf3uXmAHYF+nyeOcmEBFWkzBRAk=";
                    allowedIPs = ["10.200.200.0/24"];
                    endpoint = "185.51.76.92:51820";
                    persistentKeepalive = 25;
                }];
            };
        };
    };
}
