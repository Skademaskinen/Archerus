{ lib, self, system, ...}:

let
    mkProject = lib.mkProject;
in

{ pkgs, lib, config, ... }:

let
    pfx = config.skade.projects.putricide;
in


{
    options.skade.projects.putricide = {
        configDir = lib.mkOption {
            type = lib.types.str;
            default = "${config.skade.projectsRoot}/projects/putricide";
            description = ''
                directory to store configuration
            '';
        };
        args = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = ["--disable-teams"];
            description = ''
                Arguments to the jar file
            '';
        };
        init.status = lib.mkOption {
            type = lib.types.str;
            default = "Hello from Nix!";
            description = ''
                Status message of the bot
            '';
        };
        # only set these locally, never commit these options to git
        init.token = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = ''
                Initial discord bot token
            '';
        };
        init.wow.clientId = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = ''
                Client ID of the wow API
            '';
        };
        init.wow.clientSecret = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = ''
                Client secret of the wow API
            '';
        };

    };
    config = mkProject config {
        name = "putricide";
        exec = "${self.packages.${system}.putricide}/bin/ppbot --config ${pfx.configDir} --source ${self.packages.${system}.putricide}/share/Putricide ${builtins.toString pfx.args}";
        setup = ''
            mkdir -p ${pfx.configDir}/files/{config,log}
            if ! [ -f ${pfx.configDir}/files/config/main.json ]; then
                echo "Creating default json file"
                # using cat to create new permissions
                cat ${pkgs.writeText "main.json" (builtins.toJSON {
                    token = pfx.init.token;
                    clientId = pfx.init.wow.clientId;
                    clientSecret = pfx.init.wow.clientSecret;
                    status = pfx.init.status;
                })} > ${pfx.configDir}/files/config/main.json
            fi
        '';
    };
}
