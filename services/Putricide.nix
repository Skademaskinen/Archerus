{ config, lib, pkgs, modulesPath, ... }: let
    env = pkgs.callPackage ../packages/putricide.nix {};
in {

    systemd.services.Putricide = {
        description = "Putricide service";
        serviceConfig = {
            User = "mast3r";
            ExecStart = "${pkgs.bash}/bin/bash ${env}/bin/skademaskinen-putricide --config /mnt/raid/bots/Putricide --source ${env}/share/Putricide --disable-teams";
        };
        wantedBy = [ "default.target" ];
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
    };

    systemd.services.Putricide.enable = true;
}