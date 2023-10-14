{ config, lib, pkgs, modulesPath, ... }: {

  users.users.minecraft = {
    isSystemUser = true;
    description = "minecraft server manager";
    group = "minecraft";
    packages = with pkgs; [
      openjdk
      screen
      wget
    ];
  };
  users.groups.minecraft = {};
  
  systemd.services.minecraft-waterfall = {
    description = "minecraft waterfall service";
    serviceConfig = {
      WorkingDirectory = "/mnt/raid/minecraft/waterfall";
      User = "minecraft";
      ExecStart = "${pkgs.jdk}/bin/java -jar /mnt/raid/minecraft/waterfall/waterfall.jar";
      Restart = "on-failure";
    };
    wantedBy = [ "default.target" ];
  };

  systemd.services.minecraft-survival = {
    description = "minecraft survival service";
    serviceConfig = {
      WorkingDirectory = "/mnt/raid/minecraft/survival";
      User = "minecraft";
      ExecStart = "${pkgs.jdk}/bin/java -jar /mnt/raid/minecraft/survival/survival.jar";
      Restart = "on-failure";
    };
    wantedBy = [ "default.target" ];
  };

  systemd.services.minecraft-hub = {
    description = "minecraft hub service";
    serviceConfig = {
      WorkingDirectory = "/mnt/raid/minecraft/hub";
      User = "minecraft";
      ExecStart = "${pkgs.jdk}/bin/java -jar /mnt/raid/minecraft/hub/hub.jar";
      Restart = "on-failure";
    };
    wantedBy = [ "default.target" ];
  };

  systemd.services.minecraft-creative = {
    description = "minecraft creative service";
    serviceConfig = {
      WorkingDirectory = "/mnt/raid/minecraft/creative";
      User = "minecraft";
      ExecStart = "${pkgs.jdk}/bin/java -jar /mnt/raid/minecraft/creative/creative.jar";
      Restart = "on-failure";
    };
    wantedBy = [ "default.target" ];
  };

  systemd.services.minecraft-waterfall.enable = true;
  systemd.services.minecraft-survival.enable = true;
  systemd.services.minecraft-hub.enable = true;
  systemd.services.minecraft-creative.enable = true;
}
