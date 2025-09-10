# this is actually an internal database i will use to keep track of init states of projects internally on the server side
{ lib, nixpkgs, ... }:

config:

let
    pkgs = lib.load nixpkgs;
    file = "${config.skade.projectsRoot}/projects.db3";
    lock = "${config.skade.projectsRoot}/projects.lock";
in

rec {
    # This is safe because it is only used in string interpolation in nix, the scripts will be immutable
    acquire = "while [ -f ${lock} ]; do echo 'still locked...'; sleep 1; done; touch ${lock}";
    release = "rm -f ${lock}";

    doSQL = sql: "${pkgs.writeScriptBin "sql-script" ''
        #!${pkgs.bash}/bin/bash
        ${acquire}
        ${pkgs.sqlite-interactive}/bin/sqlite3 ${file} "${sql}"
        ${release}
    ''}/bin/sql-script";

    migrate = ''
        ${doSQL "CREATE TABLE IF NOT EXISTS projects (
            name varchar primary key,
            path varchar not null,
            initialized boolean not null
        )"}
    '';

    register = name: path: ''
        ${doSQL "INSERT INTO projects VALUES ('${name}', '${path}', false)"}
    '';

    isRegistered = name: ''[[ "$(${doSQL "SELECT count(*) FROM projects WHERE name = '${name}'"})" == "1" ]]'';

    isInitialized = name: ''${isRegistered name} && [[ "$(${doSQL "SELECT initialized from projects where name = '${name}'"})" == "1" ]]'';
    setInitialized = name: value: "${doSQL "UPDATE projects SET initialized = ${value} WHERE name = '${name}'"}";

    getAllProjects = ''$(${doSQL "SELECT name FROM projects"})'';


    # just for testing in nix-repl
    testScript = pkgs.writeScriptBin "testDatabaseScript" ''
        #!${pkgs.bash}/bin/bash
        rm -f ${file}
        ${migrate}
        if ! ${isRegistered "homepage"}; then
            echo "homepage is not registered as expected"
        else
            echo "homepage is registered???"
            exit 1
        fi
        ${register "homepage" "/mnt/raid/projects/homepage"}
        ${register "homepage1" "/mnt/raid/projects/homepage1"}
        if ${isRegistered "homepage"}; then
            echo "Homepage is registered"
        else
            echo "Homepage is somehow not registered"
        fi
        if ! ${isInitialized "homepage"}; then
            echo "Homepage is not initialized as expected"
        fi
        if ${isInitialized "homepage"}; then
            echo "Homepage is somehow initialized????"
            exit 1
        fi
        echo "Setting initialized"
        ${setInitialized "homepage" "true"}
        if ${isInitialized "homepage"} then
            echo "Homepage is initialized as expected"
            echo "All registered projects:"
            for project in ${getAllProjects}; do
                echo $project
            done
            exit 0
        fi
    '';
}
