inputs:

let 
    utils = import ./utils.nix inputs;
    pruneNixExtension = utils.pruneNixExtension;
    pkgs = utils.pkgs;
in


rec {
    mkSubmodules = args: builtins.listToAttrs (map (path: {
        name = pruneNixExtension (builtins.baseNameOf path);
        value = import path (inputs // { lib = inputs.self.lib; });
    }) args);

    mkProjectConfig = sysCfg: cfg: {
        systemd.services = {
            ${cfg.name} = {
                enable = true;
                environment = utils.setIf (cfg?environment) cfg.environment;
                serviceConfig = {
                    WorkingDirectory = "${sysCfg.skade.projectsRoot}/projects/${cfg.name}";
                    ExecStart = cfg.exec;
                } // (if cfg.stdinSocket then {
                    StandardInput = "socket";
                    StandardOutput = "journal";
                    StandardError = "journal";
                    Restart = "always";
                } else {});
                wantedBy = [ "default.target" ];
                after = [ "${cfg.name}-setup.service" "${cfg.name}.socket" ];
            };
            "${cfg.name}-setup" = {
                enable = true;
                serviceConfig = {
                    Type = "oneshot";
                    ExecStart = "${pkgs.writeScriptBin "${cfg.name}-setup" ''
                        #!${pkgs.bash}/bin/bash
                        set -e
                        proot=${sysCfg.skade.projectsRoot}/projects/${cfg.name}
                        mkdir -p ${sysCfg.skade.projectsRoot}/projects/${cfg.name}
                        ${utils.strIf cfg.stdinSocket "mkdir -p ${sysCfg.skade.projectsRoot}/sockets"}
                        ${utils.strIf (cfg?setup) cfg.setup}
                        echo "Finished setup"
                    ''}/bin/${cfg.name}-setup";
                };
                wantedBy = [ "default.target" ];
            };
        };
        systemd.sockets = if cfg.stdinSocket then {
            "${cfg.name}" = {
                enable = true;
                description = "${cfg.name} socket";
                socketConfig = {
                    ListenFIFO = "${sysCfg.skade.projectsRoot}/sockets/${cfg.name}.stdin";
                    Service = "${cfg.name}.service";
                };
                wantedBy = [ "default.target" ];
            };
        } else {};
    };

    makeProxy = sysCfg: cfg: let
        base = {
            forceSSL = cfg?secure && cfg.secure;
            locations.${cfg.path} = {
                proxyPass = cfg.location;
                proxyWebsockets = true;
            };
        };
        sslCfg = {
            sslCertificate = "${sysCfg.skade.projectsRoot}/ssl/${sysCfg.skade.baseDomain}/domain.cert.pem";
            sslCertificateKey = "${sysCfg.skade.projectsRoot}/ssl/${sysCfg.skade.baseDomain}/private.key.pem";
        };
    in if cfg?secure && cfg.secure then base // sslCfg else base;

    mkWebConfig = sysCfg: cfg: (mkProjectConfig sysCfg cfg) // (let
        name = utils.fIf cfg "subdomain" cfg.name;
        formattedName = if name == "" then "" else "${name}.";
    in {
        services.nginx.virtualHosts."${formattedName}${sysCfg.skade.baseDomain}" = makeProxy sysCfg {
            path = "/";
            location = "http://localhost:${builtins.toString cfg.port}";
            secure = utils.fIf cfg "secure" (sysCfg.skade.baseDomain != "localhost");
        };
    });
}
