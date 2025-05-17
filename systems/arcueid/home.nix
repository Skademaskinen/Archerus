{ pkgs, lib, ... }:

{
    home.stateVersion = "24.11";
    wayland.windowManager.hyprland.extraConfig = ''
        monitor = DP-1, 3840x2160, 1920x0, 2
        monitor = DP-3, 3840x2160, 0x0, 2
        exec-once =${pkgs.ckb-next}/bin/ckb-next -b
        exec-once = ${pkgs.openrgb}/bin/openrgb --startminimized -c FFFFF,FF1000
        xwayland {
          force_zero_scaling = true
        }
        
        # toolkit-specific scale
        env = GDK_SCALE,2
        env = XCURSOR_SIZE,24
        env = NIXOS_OZONE_WL=1

        misc {
            vrr = 1
        }
    '' + builtins.concatStringsSep "\n" (map (index:
        "workspace = ${builtins.toString index},monitor:DP-${if (lib.mod index 2 == 0) then "1" else "3"}"
    ) (lib.lists.range 1 10));

    desktop.battery = false;

    home.packages = with pkgs; [
        dotnet-sdk_8
    ];
}
