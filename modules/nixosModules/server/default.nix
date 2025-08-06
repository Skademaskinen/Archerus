inputs:

{ lib, config, ...}:

{
    options.skade = {
        projects = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ "dummyProject" ];
        };
        projectsRoot = lib.mkOption {
            type = lib.types.str;
            default = "/mnt/raid";
        };
    };
    imports = map (name: import (./projects + ("/" + name + ".nix")) inputs) ["dummyProject"];

    config.virtualisation.vmVariant.virtualisation.graphics = false;
}
