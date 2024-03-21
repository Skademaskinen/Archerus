{pkgs, lib, config, ...}: let
    pkg = pkgs.callPackage ../packages/sketch-bot {};
in{
    options.skademaskinen.sketch-bot = {
        enable = lib.mkOption {
            type = lib.types.bool;
            default = false;  
        };
        root = lib.mkOption {
            type = lib.types.str;
        };
    };
    config.systemd.services.sketch-bot = if config.skademaskinen.sketch-bot.enable then {
        enable = config.skademaskinen.sketch-bot.enable;
        description = "SketchBot service";
        serviceConfig = {
            WorkingDirectory = config.skademaskinen.sketch-bot.root;
            User = "taoshi";
            ExecStart = "${pkgs.bash}/bin/bash ${pkg}/bin/sketch-bot";
        };
    } else {};
}