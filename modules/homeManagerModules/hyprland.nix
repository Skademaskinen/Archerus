inputs:

{ pkgs, lib, ... }: let
    wallpaper = inputs.self.lib.wallpapers.arcueid;
    toStr = builtins.toString;
in {
    imports = [
        ./common/desktop.nix
    ];
    wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = true;
        systemd.enable = true;
        settings = {
            "$mod" = "SUPER";
            "$terminal" = "${pkgs.alacritty}/bin/alacritty";
            bind = [
                "$mod, d, exec, ${pkgs.callPackage ./common/nwg/drawer.nix {}}"
                "$mod, k, exec, ${pkgs.callPackage ./common/nwg/drawer.nix {}}"
                "$mod, Return, exec, ${pkgs.alacritty}/bin/alacritty"
                "$mod, o, exec, ${pkgs.alacritty}/bin/alacritty"
                "$mod SHIFT, q, exit"
                "$mod, q, killactive"
                "$mod, space, togglefloating"
                "$mod SHIFT, f, fullscreen"
            ] ++
                map (index: "$mod, ${toStr (lib.mod index 10)}, workspace, ${toStr index}") (lib.lists.range 1 10) ++
                map (index: "$mod SHIFT, ${toStr (lib.mod index 10)}, movetoworkspacesilent, ${toStr index}") (lib.lists.range 1 10);

            bindm = [
                "ALT, mouse:272, movewindow"
            ];

            bindel = [
                " , XF86AudioRaiseVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
                " , XF86AudioLowerVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
                " , XF86AudioMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
            ];

            exec-once = [
                "${pkgs.callPackage ./common/nwg/panel-hyprland.nix {}}"
                "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"
            ];
            general = {
                "col.active_border" = "rgba(ff5500ff) rgba(ff5500ff)";
                "col.inactive_border" = "rgba(595959ff) rgba(595959ff)";
                "col.nogroup_border" = "rgba(595959ff) rgba(595959ff)";
                "col.nogroup_border_active" = "rgba(ff5500ff) rgba(ff5500ff)";
                gaps_in = "5";
                gaps_out = "10";
                border_size = "2";
            };

            decoration = {
                rounding = "5";
                shadow = {
                    enabled = "false";
                };
            };

            input = {
                kb_layout = "dk";
            };
            gestures = {
                workspace_swipe = "true";
            };

            env = [
                "HYPRCURSOR_THEME,Vimix-cursors"
                "XCURSOR_THEME,Vimix-cursors"
                "XCURSOR_SIZE,24"
                "HYPRCURSOR_SIZE,24"
            ];
        };
    };
    programs.hyprlock.enable = true;
    services.hypridle.enable = true;
    services.hyprpaper = {
        enable = true;
        settings = {
            preload = "${wallpaper}";
            wallpaper = ", ${wallpaper}";
        };
    };

    home.packages = with pkgs; [
        hyprpaper
        vimix-cursors
    ];
    
}
