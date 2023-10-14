{ config, lib, pkgs, modulesPath, ... }: {
  #services.openvpn.enable = true;

  services.openvpn.servers = {
    VPN = {
      config = '' config /opt/VPN/windscribe.conf '';
    };
  };
}