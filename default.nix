{ config, pkgs, ... }:
  {
    imports =[
      ./hardware-configuration.nix
      
      ./users
      ./services
      ./setup
      ];
}
