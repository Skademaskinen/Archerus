{lib, pkgs, config, ... }: let
    env = pkgs.callPackage ../packages/putricide.nix {};
in {
    options.skademaskinen.putricide = {
        enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
        };
        config = lib.mkOption {
            type = lib.types.str;
        };
        args = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
        };
    };

    config.systemd.services.Putricide = {
        enable = config.skademaskinen.putricide.enable;
        description = "Putricide service";
        serviceConfig = if config.skademaskinen.putricide.enable then {
            User = "mast3r";
            ExecStart = "${pkgs.bash}/bin/bash ${env}/bin/skademaskinen-putricide --config ${config.skademaskinen.putricide.config} --source ${env}/share/Putricide ${lib.concatStrings (lib.strings.intersperse " " config.skademaskinen.putricide.args)}";
        } else {};
        wantedBy = [ "default.target" ];
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
    };
}