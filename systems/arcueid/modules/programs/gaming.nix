{ pkgs, ... }: let

    wine-discord-ipc-bridge = pkgs.callPackage ./wine-discord-ipc-bridge.nix {};

in {
    programs.steam = {
        enable = true;

    };
    programs.gamescope = {
        enable = true;
    };
    hardware.ckb-next.enable = true;

    hardware.graphics = {
        enable = true;
        enable32Bit = true;
    };

    environment.variables = {
        STEAM_GAMESCOPE_PREFIX = "${pkgs.writeScriptBin "gamescope-wrapped" ''
            #!${pkgs.bash}/bin/bash
            export LD_PRELOAD=
            export XKB_DEFAULT_LAYOUT=dk
            ${pkgs.gamescope}/bin/gamescope -W 3840 -H 2160 -w 3840 -h 2160 --adaptive-sync --mangoapp --force-grab-cursor -s 2 -e -f -- ${wine-discord-ipc-bridge}/bin/winediscordipcbridge-steam.sh $@
        ''}/bin/gamescope-wrapped";

        # baldur's gate 3 was being sPeCiAl and needs spECIaL treatment...
        BALDURS_GATE_3_PREFIX = "${pkgs.writeScriptBin "gamescope-wrapped" ''
            #!${pkgs.bash}/bin/bash
            export LD_PRELOAD=
            export XKB_DEFAULT_LAYOUT=dk
            ${pkgs.gamescope}/bin/gamescope -W 3840 -H 2160 -w 3840 -h 2160 --adaptive-sync --mangoapp -e -f -- ${wine-discord-ipc-bridge}/bin/winediscordipcbridge-steam.sh $@
        ''}/bin/gamescope-wrapped";

        STEAM_PREFIX = "${wine-discord-ipc-bridge}/bin/winediscordipcbridge-steam.sh";

        LUTRIS_GAMESCOPE_PREFIX = "${pkgs.writeScriptBin "gamescope-wrapped" ''
            #!${pkgs.bash}/bin/bash
            LD_PRELOAD=
            export XKB_DEFAULT_LAYOUT=dk
            ${pkgs.gamescope}/bin/gamescope -W 3840 -H 2160 -w 3840 -h 2160 --adaptive-sync --mangoapp --force-grab-cursor -s 2 -f -- ${wine-discord-ipc-bridge}/bin/winediscordipcbridge.exe $@
        ''}/bin/gamescope-wrapped";

        LUTRIS_PREFIX = "${wine-discord-ipc-bridge}/bin/winediscordipcbridge.exe";
    };
}
