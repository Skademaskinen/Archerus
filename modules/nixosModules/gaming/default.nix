inputs:

{ pkgs, ... }: 

let
    # Configuration files
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

    # Binary paths
    gamescope-bin = "${pkgs.gamescope}/bin/gamescope";
    gamemode-bin = "${pkgs.gamemode}/bin/gamemoderun";
    mangohud-bin = "${pkgs.mangohud}/bin/mangohud";
    ipc-steam-bin = "${inputs.self.packages.${inputs.system}.wine-discord-ipc-bridge}/bin/winediscordipcbridge-steam.sh";
    ipc-exe = "${inputs.self.packages.${inputs.system}.wine-discord-ipc-bridge}/bin/winediscordipcbridge.exe";
    lsfg-vk-so = "${inputs.self.packages.${inputs.system}.lsfg-vk}/lib/liblsfg-vk.so";

    # Common prefixes
    common-prefix = ''
        #!/bin/sh
        export MANGOHUD_CONFIGFILE=${mangohud_config}
        args="$@"
        echo "Running Command: [$args]"
        ${pkgs.libnotify}/bin/notify-send -- "Launching game..." "Args: $args"
    '';
    common-gamescope-prefix = ''
        ${common-prefix}
        export LD_PRELOAD=""
        export XKB_DEFAULT_LAYOUT=dk
    '';
    lutris-ipc-prefix = ''
        # Wine executable should be first argument
        wine_executable=$1
        # Launch IPC as a subprocess
        $wine_executable ${ipc-exe} &
    '';

    # Arguments
    gamescope-args = "-W 3840 -H 2160 -w 3840 -h 2160 --adaptive-sync --mangoapp --force-grab-cursor -s 2 -e -f --";

    # Common postfixes
    executable-postfix = "\"$@\"";

    # Actual prefixes
    prefixes = {
        # Steam prefixes
        steam-gamescope-prefix = ''
            ${common-gamescope-prefix}
            ${gamemode-bin} ${gamescope-bin} ${gamescope-args} ${ipc-steam-bin} ${executable-postfix}
        '';
        steam-prefix = ''
            ${common-prefix}
            ${gamemode-bin} ${mangohud-bin} ${ipc-steam-bin} ${executable-postfix}
        '';
        steam-gamescope-wayland-prefix = ''
            ${common-gamescope-prefix}
            DISPLAY=""
            ${gamemode-bin} ${gamescope-bin} ${gamescope-args} ${ipc-steam-bin} ${executable-postfix}
        '';
        steam-wayland-prefix = ''
            ${common-prefix}
            DISPLAY=""
            ${gamemode-bin} ${mangohud-bin} ${ipc-steam-bin} ${executable-postfix}
        '';
        #steam-lsfg-vk-prefix = ''
        #    ${common-prefix}
        #    export LD_PRELOAD="${lsfg-vk-so}"
        #    export ENABLE_LSFG=1
        #    ${gamemode-bin} ${mangohud-bin} ${ipc-steam-bin} ${executable-postfix}
        #'';

        # Lutris prefixes
        lutris-gamescope-prefix = ''
            ${common-gamescope-prefix}
            ${lutris-ipc-prefix}
            ${gamemode-bin} ${gamescope-bin} ${gamescope-args} ${executable-postfix}
        '';
        lutris-prefix = ''
            ${common-prefix}
            ${lutris-ipc-prefix}
            ${gamemode-bin} ${mangohud-bin} ${executable-postfix}
        '';
        lutris-wayland-prefix = ''
            ${common-prefix}
            ${lutris-ipc-prefix}
            DISPLAY=""
            ${gamemode-bin} ${mangohud-bin} ${executable-postfix}
        '';
    };

    # build strings to scripts
    convert = name: pkgs.writeScriptBin name prefixes.${name};
    prefix-pkgs = map convert (builtins.attrNames prefixes);
in

{
    nixpkgs.config.allowUnfree = true;

    programs.steam = {
        enable = true;
        extraPackages = prefix-pkgs;
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
        wowup-cf
        bolt-launcher
        inputs.self.packages.${inputs.system}.wine-discord-ipc-bridge
        mangohud
        inputs.self.packages.${inputs.system}.curseforge
        (writeScriptBin "test-mangohud" ''
            ${common-prefix}
            ${mangohud-bin} ${mesa-demos}/bin/glxgears -geometry 1920x1080
        '')
    ] ++ prefix-pkgs;
}
