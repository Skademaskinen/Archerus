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
    common-prefix = ''
        #!/bin/sh
        export MANGOHUD_CONFIGFILE=${mangohud_config}
        echo "Running Command: [$@]"
    '';
    common-gamescope-prefix = ''
        ${common-prefix}
        export LD_PRELOAD=""
        export XKB_DEFAULT_LAYOUT=dk
    '';
    gamescope-args = "-W 3840 -H 2160 -w 3840 -h 2160 --adaptive-sync --mangoapp --force-grab-cursor -s 2 -e -f --";
    executable-postfix = "$@";

    prefixes = with pkgs; [
        (pkgs.writeScriptBin "steam-gamescope-prefix" ''
            ${common-gamescope-prefix}
            ${gamemode}/bin/gamemoderun ${gamescope}/bin/gamescope ${gamescope-args} ${inputs.self.packages.${inputs.system}.wine-discord-ipc-bridge}/bin/winediscordipcbridge-steam.sh ${executable-postfix}
        '')
        (pkgs.writeScriptBin "steam-prefix" ''
            ${common-prefix}
            ${gamemode}/bin/gamemoderun ${mangohud}/bin/mangohud ${inputs.self.packages.${inputs.system}.wine-discord-ipc-bridge}/bin/winediscordipcbridge-steam.sh ${executable-postfix}
        '')
        (pkgs.writeScriptBin "steam-gamescope-wayland-prefix" ''
            ${common-gamescope-prefix}
            export DISPLAY=""
            ${gamemode}/bin/gamemoderun ${gamescope}/bin/gamescope ${gamescope-args} ${inputs.self.packages.${inputs.system}.wine-discord-ipc-bridge}/bin/winediscordipcbridge-steam.sh ${executable-postfix}
        '')
        (pkgs.writeScriptBin "steam-wayland-prefix" ''
            ${common-prefix}
            DISPLAY=""
            ${gamemode}/bin/gamemoderun ${mangohud}/bin/mangohud ${inputs.self.packages.${inputs.system}.wine-discord-ipc-bridge}/bin/winediscordipcbridge-steam.sh ${executable-postfix}
        '')

        inputs.self.packages.${inputs.system}.wine-discord-ipc-bridge
        mangohud

        (pkgs.writeScriptBin "lutris-gamescope-prefix" ''
            ${common-gamescope-prefix}
            ${gamemode}/bin/gamemoderun ${gamescope}/bin/gamescope ${gamescope-args} ${inputs.self.packages.${inputs.system}.wine-discord-ipc-bridge}/bin/winediscordipcbridge.exe $COMMAND
        '')
        (writeScriptBin "test-mangohud" ''
            ${common-prefix}
            ${mangohud}/bin/mangohud ${mesa-demos}/bin/glxgears -geometry 1920x1080
        '')
    ];
in

{
    nixpkgs.config.allowUnfree = true;

    programs.steam = {
        enable = true;
        extraPackages = prefixes;
    };
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
        inputs.self.packages.${inputs.system}.bolt
    ] ++ prefixes;
}
