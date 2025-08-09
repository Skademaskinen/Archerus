{ nixpkgs, lib, ... }:

# this file exists for the test and deployment environment, i don't want to introduce another dependency like sops-nix right now

config: let
    pkgs = lib.load nixpkgs;
    scripts = [
        ''
            import json
            with open("${config.skade.projectsRoot}/projects/folkevognen/settings.json", "r") as file:
                data = json.loads(file.read())
            data["token"] = input("Please input discord bot token: ")
            with open("${config.skade.projectsRoot}/projects/folkevognen/settings.json", "w") as file:
                file.write(json.dumps(data, indent=4))
        ''
    ];

in
    pkgs.writeScriptBin "secretHandler" ''
        #!${pkgs.bash}/bin/bash
        echo "This script will attempt to fill secrets that are not suited for storage in the repository directly"
        for script in ${builtins.toString (map (pkgs.writeText "script.py") scripts)}; do
            ${(pkgs.python312.withPackages (py: [])).interpreter} $script
        done
    ''
