{ config, lib, pkgs, modulesPath, ... }: {

  systemd.services.SketchBot = {
    description = "SketchBot service";
    serviceConfig = {
      WorkingDirectory = "/home/taoshi/SketchBot/SketchBot";
      User = "taoshi";
      ExecStart = "${pkgs.dotnet-sdk_7}/bin/dotnet run";
    };
    wantedBy = [ "default.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
  };

  systemd.services.SketchBot.enable = true;
}