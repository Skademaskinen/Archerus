{ lib, ... }:

{ config, pkgs, ...}: 

lib.mkProject config {
    name = "palworld";
    exec = "${config.skade.projectsRoot}/projects/palworld/PalServer.sh";
    setup = ''
        ${pkgs.steamcmd}/bin/steamcmd +login anonymous +force_install_dir "${config.skade.projectsRoot}/projects/palworld" +login anonymous +app_update 2394010 +quit
    '';
}
