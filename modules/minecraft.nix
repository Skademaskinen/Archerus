{config, lib, pkgs, ... }: let
    cfg = config.skademaskinen.minecraft;
    prefix = "${config.skademaskinen.storage}/minecraft";

    paper-wrapped = import ./minecraft/paper.nix {config = config; pkgs = pkgs;};
    velocity-wrapped = import ./minecraft/velocity.nix {config = config; pkgs = pkgs;};
in {
    options.skademaskinen.minecraft = with lib.types; {
        servers = lib.mkOption {
            type = listOf str;
            default = [];
        };
        fallback = lib.mkOption {
            type = str;
            default = builtins.elemAt cfg.servers 0;
        };
        secret = lib.mkOption {
            type = str;
            default = "velocity-secret";
        };
        icon = lib.mkOption {
            type = path;
            default = null;
        };
        motd = lib.mkOption {
            type = str;
            default = "<rainbow>Minecraft server";
        };
        port-range-start = lib.mkOption {
            type = int;
            default = 25565;
        };
    };

    config = {
        systemd.services = let 
            velocity = {
                name = "minecraft-velocity";
                value = {
                    enable = true;
                    serviceConfig = {
                        ExecStart = "${pkgs.bash}/bin/bash ${velocity-wrapped}/bin/velocity-wrapped";
                    };
                    wantedBy = ["default.target"];
                };
            };
        in lib.listToAttrs (lib.concatLists [[velocity] (map (name: {
            name = "minecraft-${name}";
            value = {
                enable = true;
                serviceConfig = {
                    ExecStart = "${pkgs.bash}/bin/bash ${paper-wrapped name}/bin/paper-wrapped";
                };
                wantedBy = ["default.target"];
            };
        }) cfg.servers)]);
    };
}
