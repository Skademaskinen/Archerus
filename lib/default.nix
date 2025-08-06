{ nixpkgs, ... } @ inputs:

rec {
    stringTail = string: offset:
        builtins.substring offset (builtins.stringLength string) string;

    capitalize = string: let
        words = nixpkgs.lib.strings.splitString " " string;
        capitalizedWords = builtins.map (word:
            (nixpkgs.lib.strings.toUpper (builtins.substring 0 1 word)) + stringTail word 1
        ) words;
    in builtins.concatStringsSep " " capitalizedWords;

    wallpapers = import ./wallpapers.nix inputs;

    pruneNixExtension = pathName: builtins.elemAt (builtins.split ".nix" pathName) 0;

    mkSubmodules = args: builtins.listToAttrs (map (path: {
        name = pruneNixExtension (builtins.baseNameOf path);
        value = import path (inputs // { lib = inputs.self.lib; });
    }) args);

    iCall = path: import path (inputs // { lib = inputs.self.lib; });

    pkgs = import nixpkgs { system = inputs.system; };

    mkProjectConfig = sysCfg: cfg: {
        systemd.services = {
            ${cfg.name} = {
                enable = true;
                environment = cfg.environment;
                serviceConfig = {
                    WorkingDirectory = "${sysCfg.skade.projectsRoot}/${cfg.name}";
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
                        mkdir -p ${sysCfg.skade.projectsRoot}/${cfg.name}
                        ${if cfg.stdinSocket then "mkdir -p ${sysCfg.skade.projectsRoot}/sockets" else ""}
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
}
