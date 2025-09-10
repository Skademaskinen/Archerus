{ nix-gaming, system, archerusPkgs, ... }:

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

    gaming_executables_config = pkgs.writeText "config.json" (builtins.toJSON [
        {
            name = "wayland";
            priority = 0;
            environment.DISPLAY = "";
        }
        {
            name = "x11";
            priority = 0;
            environment.WAYLAND_DISPLAY = "";
        }
        {
            name = "gamemode";
            path = "${pkgs.gamemode}/bin/gamemoderun";
            priority = 1;
        }
        {
            name = "mangohud";
            path = "${pkgs.mangohud}/bin/mangohud";
            priority = 2;
            environment.MANGOHUD_CONFIGFILE = mangohud_config;
        }
        {
            name = "gamescope";
            path = "${pkgs.gamescope}/bin/gamescope";
            arguments = [ "-W" "3840" "-H" "2160" "-w" "3840" "-h" "2160" "--adaptive-sync" "--mangoapp" "--force-grab-cursor" "-s" "2" "-e" "-f" "--" ];
            priority = 3;
        }
        {
            name = "ipc_bridge";
            path = "${nix-gaming.packages.${system}.wine-discord-ipc-bridge}/bin/winediscordipcbridge-steam.sh";
            priority = 4;
        }
    ]);
in

{
    nixpkgs.config.allowUnfree = true;

    programs.steam = {
        enable = true;
        extraPackages = [
            archerusPkgs.gamingPrefix
        ];
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
        GAMING_PREFIX_ICON = "${archerusPkgs.homepage.src}/static/icon.png";
        GAMING_EXECUTABLES_CONFIG = gaming_executables_config;
    };

    environment.systemPackages = with pkgs; [

        archerusPkgs.gamingPrefix
        lutris
        wine
        protonup-qt
        wowup-cf
        bolt-launcher
        nix-gaming.packages.${system}.wine-discord-ipc-bridge
        mangohud
        archerusPkgs.curseforge
    ];
}
