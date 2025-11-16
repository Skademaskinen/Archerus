{ archerusPkgs, ... }:

{ pkgs, lib, config, ... }: let
    toStr = builtins.toString;
    terminal = config.skade.hyprland.terminal;
in {
    options.skade.hyprland = {
        battery.enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
        };
        terminal = {
            package = lib.mkOption {
                type = lib.types.package;
                default = pkgs.kitty;
            };
            arguments = {
                workingDirectory = lib.mkOption {
                    type = lib.types.str;
                    default = "--working-directory";
                };
                command = lib.mkOption {
                    type = lib.types.str;
                    default = "";
                };
            };
            executable = lib.mkOption {
                type = lib.types.str;
                default = "${terminal.package}/bin/${terminal.package.meta.mainProgram}";
            };
            run = lib.mkOption {
                default = wd: cmd: "${terminal.executable} ${terminal.arguments.workingDirectory} ${wd} ${terminal.arguments.command} ${cmd}";
            };
        };
    };
    config = {
        wayland.windowManager.hyprland = {
            enable = true;
            xwayland.enable = true;
            systemd.enable = true;
            settings = {
                "$mod" = "SUPER";
                "$terminal" = "${terminal.executable}";
                bind = [
                    "$mod, Return, exec, ${terminal.executable}"
                    "$mod SHIFT, e, exec, ${archerusPkgs.dialog "You pressed the exit shortcut, are you sure you want to exit hyprland?" "${pkgs.hyprland}/bin/hyprctl dispatch exit"}"
                    "$mod SHIFT, q, killactive"
                    "$mod, space, togglefloating"
                    "$mod, l, exec, ${pkgs.hyprlock}/bin/hyprlock"
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
                    #workspace_swipe = "true";
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
        programs.hyprlock.enable = true;
        #services.hypridle.enable = true;


        home.packages = with pkgs; [
            hyprlock
            hyprpaper
            vimix-cursors
            wl-clipboard
            networkmanagerapplet
        ];

    };
    
}
