inputs:

{ lib, ...}:

{
    options.skade = {
        projectsRoot = lib.mkOption {
            type = lib.types.path;
            default = /mnt/raid/projects;
        };
    };
}
