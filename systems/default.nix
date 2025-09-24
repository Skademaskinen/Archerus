{ lib, ... }@inputs:

with builtins;

let 
    genHosts = paths: listToAttrs (map (path: {
        name = lib.capitalize (baseNameOf path);
        value = path;
    }) paths);
in

mapAttrs (name: path: import path inputs) (genHosts [
    ./arcueid
    ./laptop
    ./skademaskinen
    ./thinkpad
    ./kohaku
    ./hisui
])
