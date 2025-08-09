{ lib, nixpkgs, ...}:

let
    pkgs = lib.load nixpkgs;
in

sysCfg: { stdinSocket ? false, name, exec, environment ? {}, setup ? "", ... }: let 
in {
    systemd.services = {
        ${name} = {
            inherit environment;
            enable = true;
            serviceConfig = {
                WorkingDirectory = "${sysCfg.skade.projectsRoot}/projects/${name}";
                ExecStart = exec;
                StandardInput = if stdinSocket then "socket" else "inherit";
                StandardOutput = "journal";
                StandardError = "journal";
                Restart = "always";
            };
            wantedBy = [ "default.target" ];
            after = [ "${name}-setup.service" "${name}.socket" ];
        };
        "${name}-setup" = {
            enable = true;
            serviceConfig = {
                Type = "oneshot";
                ExecStart = "${pkgs.writeScriptBin "${name}-setup" ''
                    #!${pkgs.bash}/bin/bash
                    set -e
                    proot=${sysCfg.skade.projectsRoot}/projects/${name}
                    mkdir -p ${sysCfg.skade.projectsRoot}/projects/${name}
                    ${lib.strIf stdinSocket "mkdir -p ${sysCfg.skade.projectsRoot}/sockets"}
                    ${setup}
                    echo "Finished setup"
                ''}/bin/${name}-setup";
            };
            wantedBy = [ "default.target" ];
        };
    };
    systemd.sockets = lib.setIf stdinSocket {
        "${name}" = {
            enable = true;
            description = "${name} socket";
            socketConfig = {
                ListenFIFO = "${sysCfg.skade.projectsRoot}/sockets/${name}.stdin";
                Service = "${name}.service";
            };
            wantedBy = [ "default.target" ];
        };
    };
}
