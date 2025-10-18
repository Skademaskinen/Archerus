{ pkgs, lib, ... }:

{

    wayland.windowManager.hyprland.extraConfig = ''
        monitor = DP-3, 3840x2160, 1920x0, 2
        monitor = DP-1, 3840x2160, 0x0, 2
        exec-once = ${pkgs.ckb-next}/bin/ckb-next -b
        exec-once = ${pkgs.openrgb}/bin/openrgb --startminimized
        exec-once = ${pkgs.openrgb}/bin/openrgb -d 0 -m direct -c "FF1000"
        windowrulev2 = nofocus,floating:1,class:net-runelite-client-RuneLite,title:^(win\d+)$
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
        "workspace = ${builtins.toString index},monitor:DP-${if (lib.mod index 2 == 0) then "3" else "1"}"
    ) (lib.lists.range 1 10));

    skade.hyprland.battery.enable = false;

    home.packages = with pkgs; [
        dotnet-sdk_8
        ntfs3g
        gimp
        teams-for-linux
        nvtopPackages.amd
        htop
        libreoffice
        kdePackages.okular
    ];
}
