inputs:

{ pkgs, ... }: let
    mangohud_config = pkgs.writeText "mangohud.conf" ''
        gpu_temp
        gpu_fan
        gpu_load_change
        gpu_color=FF5500
        gpu_name

        cpu_temp
        cpu_color=FF5500
        cpu_load_change
        core_bars

        dynamic_frame_timing
        gamemode

        ram_color=FF5500
        ram
        vram_color=FF5500
        vram

        resolution
        vulkan_driver
        mangoapp_steam

        fps
        fps_color_change
    '';
in

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

    programs.obs-studio.enable = true;

    users.users.mast3r.extraGroups = [ "gamemode" ];

    environment.variables = {
        MANGOHUD_CONFIGFILE = mangohud_config;
    };

    environment.systemPackages = with pkgs; [
        lutris
        wine
        protonup-qt
        bolt-launcher
        (pkgs.writeScriptBin "steam-gamescope-prefix" ''
            #!${bash}/bin/bash
            export LD_PRELOAD=
            export XKB_DEFAULT_LAYOUT=dk
            export MANGOHUD_CONFIGFILE=${mangohud_config}
            ${gamemode}/bin/gamemoderun ${gamescope}/bin/gamescope -W 3840 -H 2160 -w 3840 -h 2160 --adaptive-sync --mangoapp --force-grab-cursor -s 2 -e -f -- ${inputs.self.packages.${inputs.system}.wine-discord-ipc-bridge}/bin/winediscordipcbridge-steam.sh $@
        '')
        (pkgs.writeScriptBin "steam-prefix" ''
            #!${bash}/bin/bash
            export MANGOHUD_CONFIGFILE=${mangohud_config}
            ${gamemode}/bin/gamemoderun ${mangohud}/bin/mangohud ${inputs.self.packages.${inputs.system}.wine-discord-ipc-bridge}/bin/winediscordipcbridge-steam.sh $@
        '')

        inputs.self.packages.${inputs.system}.wine-discord-ipc-bridge
        mangohud

        (pkgs.writeScriptBin "lutris-gamescope-prefix" ''
            #!${bash}/bin/bash
            LD_PRELOAD=
            export XKB_DEFAULT_LAYOUT=dk
            export MANGOHUD_CONFIGFILE=${mangohud_config}
            ${gamescope}/bin/gamescope -W 3840 -H 2160 -w 3840 -h 2160 --adaptive-sync --mangoapp --force-grab-cursor -s 2 -f -- ${gamemode}/bin/gamemoderun ${inputs.self.packages.${inputs.system}.wine-discord-ipc-bridge}/bin/winediscordipcbridge.exe $@
        '')
        (writeScriptBin "test-mangohud" ''
            #!${bash}/bin/bash
            export MANGOHUD_CONFIGFILE=${mangohud_config}
            ${mangohud}/bin/mangohud ${mesa-demos}/bin/glxgears -geometry 1920x1080
        '')
    ];

}
