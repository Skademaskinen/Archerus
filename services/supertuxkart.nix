{ config, lib, pkgs, modulesPath, ... }: {
  users.users.supertuxkart = {
    isSystemUser = true;
    description = "Supertuxkart server manager";
    group = "supertuxkart";
    packages = with pkgs; [
      superTuxKart
      docker
      docker-compose
    ];
  };
  users.groups.supertuxkart = {};

  systemd.services.supertuxkart = {
    enable = true;
    description = "Supertuxkart server";
    serviceConfig = {
      User = "supertuxkart";
      Environment="XDG_CONFIG_DIRS=/mnt/raid/supertuxkart";
      ExecStart = "${pkgs.superTuxKart}/bin/supertuxkart --server-password='aau-sw-2023-stk' --wan-server=true --unlock-all --root=/mnt/raid/supertuxkart --port=40000";
      Restart = "on-failure";
    };
    wantedBy = [ "default.target" ];
  };
}