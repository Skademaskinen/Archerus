inputs:

{ pkgs, ... }:

{    programs.direnv = {
        enable = true;
        enableZshIntegration = true;
    
    
    };    

    virtualisation.docker.enable = true;
    users.groups.docker.members = [
        "mast3r"
    ];
    programs.git.enable = true;
    environment.systemPackages = with pkgs; [
        unzip
        zip
        jq
        (pkgs.writeScriptBin "runcpp" ''
            #!/usr/bin/env bash
            FILE=$(mktemp)
            ${gcc}/bin/g++ -o $FILE $@ && $FILE
        '')
    ];
}
