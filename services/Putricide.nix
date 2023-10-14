{ config, lib, pkgs, modulesPath, ... }: {

  systemd.services.Putricide = {
    description = "Putricide service";
    serviceConfig = {
      WorkingDirectory = "/home/mast3r/bots/Putricide";
      User = "mast3r";
      ExecStart = "${pkgs.jdk}/bin/java -jar /home/mast3r/bots/Putricide/ppbot.jar --disable-teams";
    };
    wantedBy = [ "default.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
  };

  systemd.services.Putricide.enable = true;
}