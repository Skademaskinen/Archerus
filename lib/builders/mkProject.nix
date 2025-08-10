{ lib, nixpkgs, ...}:

let
    pkgs = lib.load nixpkgs;
in

sysCfg: { stdinSocket ? false, name, exec, environment ? {}, setup ? "", runAsRoot ? false, ... }: let 
    database = lib.database sysCfg;
    user = if runAsRoot then "root" else name;
in {
    systemd.services = {
        ${name} = {
            inherit environment;
            enable = true;
            serviceConfig = {
                WorkingDirectory = "${sysCfg.skade.projectsRoot}/projects/${name}";
                ExecStart = exec;
                User = user;
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
                    if ${database.isInitialized name}; then
                        echo "Already setup"
                        exit 0
                    fi
                    if ! ${database.isRegistered name}; then
                        ${database.register name "${sysCfg.skade.projectsRoot}/projects/${name}"}
                    fi
                    proot=${sysCfg.skade.projectsRoot}/projects/${name}
                    if [ -d $proot ]; then
                        echo "Project directory already exists, skipping..."
                        exit 0
                    fi
                    mkdir -p $proot
                    ${lib.strIf stdinSocket "mkdir -p ${sysCfg.skade.projectsRoot}/sockets"}
                    ${setup}
                    chown -R ${name}:${name} $proot
                    ${database.setInitialized name "true"}
                    echo "Finished setup"
                ''}/bin/${name}-setup";
            };
            wantedBy = [ "default.target" ];
            after = [ "baseSetup.service" ];
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
    environment = lib.setIf stdinSocket {
        systemPackages = [
            (pkgs.writeScriptBin "${name}.stdin" ''
                #!${pkgs.bash}/bin/bash
                MESSAGE=$1
                echo "Writing to ${sysCfg.skade.projectsRoot}/sockets/${name}.stdin"
                echo "$MESSAGE" > ${sysCfg.skade.projectsRoot}/sockets/${name}.stdin
            '')
        ];
    };
} // (lib.setIf (!runAsRoot) {
    users.users.${name} = {
        isSystemUser = true;
        extraGroups = [];
        group = name;
    };
    users.groups.${name} = {};
})
