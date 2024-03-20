{pkgs, lib, config, ...}: {
    options.wow.warcraftlogs.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
    };

    config.environment.systemPackages = if config.wow.warcraftlogs.enable then [(pkgs.callPackage ../packages/warcraftlogsuploader.nix {})] else [];
}