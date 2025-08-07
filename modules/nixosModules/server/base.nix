inputs:

{ lib, ...}:

{
    options.skade = {
        projectsRoot = lib.mkOption {
            type = lib.types.str;
            default = "/mnt/raid";
        };
    };
    config.virtualisation.vmVariant.virtualisation.graphics = false;
}
