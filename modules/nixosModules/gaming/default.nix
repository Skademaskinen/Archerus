inputs:

{ pkgs, ... }:

{
    nixpkgs.config.allowUnfree = true;

    programs.steam.enable = true;
    programs.gamescope.enable = true;

    hardware.graphics = {
        enable = true;
        enable32Bit = true;
    };
    programs.gamemode.enable = true;
    programs.gamemode.enableRenice = true;

    users.users.mast3r.extraGroups = [ "gamemode" ];

    environment.systemPackages = with pkgs; [
        lutris
        wine
        protonup-qt
        inputs.self.packages.${inputs.system}.bolt
        (pkgs.writeScriptBin "steam-gamescope-prefix" ''
            #!${bash}/bin/bash
            export LD_PRELOAD=
            export XKB_DEFAULT_LAYOUT=dk
            ${gamemode}/bin/gamemoderun ${gamescope}/bin/gamescope -W 3840 -H 2160 -w 3840 -h 2160 --adaptive-sync --mangoapp --force-grab-cursor -s 2 -e -f -- ${inputs.self.packages.${inputs.system}.wine-discord-ipc-bridge}/bin/winediscordipcbridge-steam.sh $@
        '')
        (pkgs.writeScriptBin "steam-prefix" ''
            #!${bash}/bin/bash
            ${gamemode}/bin/gamemoderun ${mangohud}/bin/mangohud ${inputs.self.packages.${inputs.system}.wine-discord-ipc-bridge}/bin/winediscordipcbridge-steam.sh $@
        '')

        inputs.self.packages.${inputs.system}.wine-discord-ipc-bridge

        (pkgs.writeScriptBin "lutris-gamescope-prefix" ''
            #!${bash}/bin/bash
            LD_PRELOAD=
            export XKB_DEFAULT_LAYOUT=dk
            ${gamescope}/bin/gamescope -W 3840 -H 2160 -w 3840 -h 2160 --adaptive-sync --mangoapp --force-grab-cursor -s 2 -f -- ${gamemode}/bin/gamemoderun ${inputs.self.packages.${inputs.system}.wine-discord-ipc-bridge}/bin/winediscordipcbridge.exe $@
        '')
    ];

}
