{pkgs, lib, config, ...}: {
    options.skademaskinen.sketch-bot = {
        enable = lib.mkOption {
            type = lib.types.bool;
            default = false;  
        };
        root = lib.mkOption {
            type = lib.types.str;
        };
    };
    config.systemd.services.sketch-bot = if config.skademaskinen.sketch-bot.enable then let
        #pkg = pkgs.callPackage ../packages/sketch-bot {};
    in {
        enable = true;
        description = "SketchBot service";
        serviceConfig = {
            WorkingDirectory = config.skademaskinen.sketch-bot.root;
            User = "taoshi";
            ExecStart = "${pkgs.dotnet-sdk_8}/bin/dotnet run";
        };
        wantedBy = [ "default.target" ];
    } else {};
}