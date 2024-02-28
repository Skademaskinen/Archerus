{ config, lib, pkgs, modulesPath, ... }: {

    systemd.services.lavalink = {
        description = "Lavalink service";
        serviceConfig = {
            WorkingDirectory = "/home/taoshi/SketchBot/SketchBot";
            User = "taoshi";
            ExecStart = "${pkgs.jdk}/bin/java -jar /home/taoshi/SketchBot/SketchBot/Lavalink.jar";
        };
        wantedBy = [ "default.target" ];
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
    };

    systemd.services.lavalink.enable = true;
}
