{ config, lib, pkgs, modulesPath, ... }: {

  systemd.services.WOL-bot = {
    description = "Wake-on-LAN bot service";
    serviceConfig = {
      WorkingDirectory = "/home/mast3r/bots/wol";
      User = "mast3r";
      ExecStart = "${pkgs.jdk}/bin/java -jar /home/mast3r/bots/wol/wol.jar";
    };
    wantedBy = [ "default.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
  };
  
  systemd.services.WOL-bot.enable = false;
}
