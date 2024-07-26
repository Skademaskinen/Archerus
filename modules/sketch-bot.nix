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
    config.systemd.services.sketch-bot = let
        pkg = pkgs.callPackage ../packages/sketch-bot {};
    in {
        enable = config.skademaskinen.sketch-bot.enable;
        description = "SketchBot service";
        serviceConfig = {
            WorkingDirectory = config.skademaskinen.sketch-bot.root;
            User = "taoshi";
            ExecStart = "${pkg}/bin/SketchBot";
        };
        wantedBy = [ "default.target" ];
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
    };

    config.systemd.services.sketch-bot-setup = {
        enable = config.skademaskinen.sketch-bot.enable;
        serviceConfig = {
            type = "oneshot";
            ExecStart = "${pkgs.bash}/bin/bash ${pkgs.writeScriptBin "sketch-bot-setup" ''
                mkdir -p ${config.skademaskinen.sketch-bot.root}
                chown -R taoshi:wheel ${config.skademaskinen.sketch-bot.root}
            ''}/bin/sketch-bot-setup";
        };
        wantedBy = ["default.target"];
        before = ["sketch-bot.service" "lavalink.service"];
    };

    config.systemd.services.lavalink = let
        lavalink = pkgs.callPackage ../packages/lavalink {};
    in {
        enable = config.skademaskinen.sketch-bot.enable;
        description = "Lavalink service";
        serviceConfig = {
            WorkingDirectory = config.skademaskinen.sketch-bot.root;
            User = "taoshi";
            ExecStart = "${pkgs.jdk}/bin/java -jar ${lavalink}/bin/lavalink";
        };
        wantedBy = [ "default.target" ];
    };
}