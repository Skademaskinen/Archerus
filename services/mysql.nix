{ config, lib, pkgs, modulesPath, ... }: {
  services.mysql.enable = true;
  services.mysql.dataDir = "/mnt/raid/mysql";
  services.mysql.package = pkgs.mysql;
  #services.mysql.socket = "/mnt/raid/mysql/mysql.sock";
}