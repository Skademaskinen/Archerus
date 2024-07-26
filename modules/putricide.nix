{lib, pkgs, config, ... }: let
    enable = config.skademaskinen.putricide.enable;
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

    config.systemd.services.Putricide = if !enable then {} else let
        env = pkgs.callPackage ../packages/putricide {};
    in {
        enable = enable;
        description = "Putricide service";
        serviceConfig = {
            User = "mast3r";
            ExecStart = "${pkgs.bash}/bin/bash ${env}/bin/skademaskinen-putricide --config ${config.skademaskinen.putricide.config} --source ${env}/share/Putricide ${lib.concatStrings (lib.strings.intersperse " " config.skademaskinen.putricide.args)}";
        };
        wantedBy = [ "default.target" ];
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
    };
}