{ lib, nixpkgs, ... }:

config:

let
    pkgs = lib.load nixpkgs;
    database = lib.database config;
in

{
    reinit = pkgs.writeScriptBin "reinitProjects" ''
        #!${pkgs.bash}/bin/bash
        if [ -z $1 ]; then
            echo "WARNING: resetting all projects"
            ${database.doSQL "UPDATE projects SET initialized = false"}
            for project in ${database.getAllProjects}; do
                systemctl start $project-setup
            done
            exit 0
        fi
        ${database.doSQL "UPDATE projects SET initialized = false WHERE name = '$1'"}
        systemctl start $1-setup
    
    '';
    getInitialized = pkgs.writeScriptBin "getInitialized" ''
        #!${pkgs.bash}/bin/bash
        ${database.doSQL "SELECT initialized FROM projects"}
    '';

    secretHandler = let
        scripts = {
            folkevognen = ''
                import json
                with open("${config.skade.projectsRoot}/projects/folkevognen/settings.json", "r") as file:
                    data = json.loads(file.read())
                data["token"] = input("Please input discord bot token for folkevognen: ")
                with open("${config.skade.projectsRoot}/projects/folkevognen/settings.json", "w") as file:
                    file.write(json.dumps(data, indent=4))
            '';
            putricide = ''
                import json
                with open("${config.skade.projects.putricide.configDir}/files/config/main.json", "r") as file:
                    data = json.loads(file.read())
                data["token"] = input("Please input discord bot token for putricide: ")
                with open("${config.skade.projects.putricide.configDir}/files/config/main.json", "w") as file:
                    file.write(json.dumps(data, indent=4))
            '';
        };
    
    in
        pkgs.writeScriptBin "secretHandler" ''
            #!${pkgs.bash}/bin/bash
            echo "This script will attempt to fill secrets that are not suited for storage in the repository directly"
            for script in ${builtins.toString (map (pkgs.writeText "script.py") (builtins.attrValues scripts))}; do
                ${(pkgs.python312.withPackages (py: [])).interpreter} $script
            done
            echo "Restarting services..."
            for service in ${builtins.toString (builtins.attrNames scripts)}; do
                systemctl restart $service
            done
        '';
}
