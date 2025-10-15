inputs:

{ pkgs, lib, ... }: let
    toStr = builtins.toString;
in {
    options.skade.hyprland = {
        battery.enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
        };
    };
    config = {
        wayland.windowManager.hyprland = {
            enable = true;
            xwayland.enable = true;
            systemd.enable = true;
            settings = {
                "$mod" = "SUPER";
                "$terminal" = "${pkgs.kitty}/bin/kitty";
                bind = [
                    "$mod, Return, exec, ${pkgs.kitty}/bin/kitty"
                    "$mod SHIFT, e, exec, ${pkgs.sway}/bin/swaynag -t warning -m 'You pressed the exit shortcut, are you sure you want to exit hyprland?' -b 'Yes, exit hyprland' '${pkgs.hyprland}/bin/hyprctl dispatch exit'"
                    "$mod SHIFT, q, killactive"
                    "$mod, space, togglefloating"
                    "$mod SHIFT, f, fullscreen"
                    ''$mod, p, exec, ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp -d)" - | ${pkgs.wl-clipboard}/bin/wl-copy''
                ] ++
                    map (index: "$mod, ${toStr (lib.mod index 10)}, workspace, ${toStr index}") (lib.lists.range 1 10) ++
                    map (index: "$mod SHIFT, ${toStr (lib.mod index 10)}, movetoworkspacesilent, ${toStr index}") (lib.lists.range 1 10);

                bindm = [
                    "$mod, mouse:272, movewindow"
                    "$mod ALT, mouse:272, resizewindow"
                ];

                bindel = [
                    " , XF86AudioRaiseVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
                    " , XF86AudioLowerVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
                    " , XF86AudioMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
                ];

                exec-once = [
                    "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"
                ];
                general = {
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
                    workspace_swipe_forever = "true";
                };

                env = [
                    "HYPRCURSOR_THEME,Adwaita"
                    "XCURSOR_THEME,Adwaita"
                    "XCURSOR_SIZE,24"
                    "HYPRCURSOR_SIZE,24"
                ];
            };
        };
        #programs.hyprlock.enable = true;
        #services.hypridle.enable = true;


        home.packages = with pkgs; [
            hyprpaper
            vimix-cursors
            wl-clipboard
            networkmanagerapplet
        ];

    };
    
}
