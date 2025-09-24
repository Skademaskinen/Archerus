{ lib, archerusPkgs, self, system, ...}:

let
    mkProject = lib.mkProject;
in

{ pkgs, lib, config, ...}:

{
    options.skade.projects.folkevognen = {
        token = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = ''
                Discord bot token, generate it here: https://discord.com/developers/applications
            '';
        };
    };
    config = mkProject config {
        name = "folkevognen";
        exec = "${archerusPkgs.folkevognen}/bin/Folkevognen";
        setup = ''
            if ! [ -f ${config.skade.projectsRoot}/projects/folkevognen/settings.json ]; then
                echo "Creating default json file"
                # using cat to create new permissions
                cat ${pkgs.writeText "settings.json" (builtins.toJSON {
                    token = config.skade.projects.folkevognen.token;
                    lastFolkedWeek = 32;
                    lastFolkedYear = 2025;
                    lastFolker = "";
                    folkevognen = {};
                })} > ${config.skade.projectsRoot}/projects/folkevognen/settings.json
            fi
        '';
    };
}
