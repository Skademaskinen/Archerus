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
        pkg = pkgs.callPackage ../packages/sketch-bot {};
    in {
        enable = true;
        description = "SketchBot service";
        serviceConfig = {
            WorkingDirectory = config.skademaskinen.sketch-bot.root;
            User = "taoshi";
            ExecStart = "${pkg}/bin/SketchBot";
        };
        wantedBy = [ "default.target" ];
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
    } else {};

    config.systemd.services.lavalink = if config.skademaskinen.sketch-bot.enable then let
        lavalink = pkgs.callPackage ../packages/lavalink {};
    in {
        enable = true;
        description = "Lavalink service";
        serviceConfig = {
            WorkingDirectory = "${lavalink}/share/lavalink";
            User = "taoshi";
            ExecStart = "${pkgs.jdk}/bin/java -jar ${lavalink}/bin/lavalink";
        };
        wantedBy = [ "default.target" ];
    } else {};
}