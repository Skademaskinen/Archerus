{pkgs, config, lib, ...}: 

{
    package = pkgs.swayfx;
    checkConfig = false;
    enable = true;
    config = {
        bars = [{
            colors.statusline = "#ffffff";
            colors.background = "#00000088";
            colors.inactiveWorkspace = {
                background = "#000000";
                border = "#32323200";
                text = "#555555";
            };
            colors.focusedWorkspace = {
                background = "#000000";
                border = "#ff5500";
                text = "#ffffff";
            };
            fonts = {
                names = ["firacode"];
                size = 12.0;
            };
            position = "top";
            statusCommand = import ../../common/status.nix {inherit pkgs;};
        }];
        colors.focused = {
            border = "#ff5500";
            background = "#00000077";
            childBorder = "#ff5500";
            indicator = "#ff5500";
            text = "#ffffff";
        };
        colors.unfocused = {
            border = "#444444";
            background = "#00000077";
            childBorder = "#444444";
            indicator = "#ff5500";
            text = "#ffffff";
        };
        window.border = 1;
        window.titlebar = false;
        terminal = "${pkgs.alacritty}/bin/alacritty";
        gaps.inner = 3;
        gaps.outer = 3;
        modifier = "Mod4";
        menu = "${pkgs.rofi-wayland}/bin/rofi -show run";
        input."type:keyboard" = {
            xkb_layout = "dk";
        };
        input."type:touchpad" = {
            dwt = "enabled";
            tap = "enabled";
            middle_emulation = "enabled";
        };

        output."*" = {
            bg = "${../../common/bg.png} fill mode 1920x1080";
        };

        startup = map (command: {command = command;}) [
            "${pkgs.dunst}/bin/dunst"
            "gentoo-pipewire-launcher restart &"
        ];

        defaultWorkspace = "workspace number 1";

        floating.criteria = [
            {
                class = "feh";
            }
            {
                class = "ffplay";
            }
        ];

        keybindings = let
            modifier = config.wayland.windowManager.sway.config.modifier;
        in lib.mkOptionDefault {
            "${modifier}+l" = ''exec swaylock --show-failed-attempts --ignore-empty-password -i ${../../common/bg.png}'';
            "${modifier}+p" = ''exec ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp -d)" - | ${pkgs.wl-clipboard}/bin/wl-copy'';
            "Ctrl+Shift+Mod1+${modifier}+l" = "exec ${pkgs.xdg-utils}/bin/xdg-open https://linkedin.com";
            "XF86AudioMute" = ''exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_SINK@ toggle'';
            "XF86AudioRaiseVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume -l 1.0 @DEFAULT_SINK@ 5%+";
            "XF86AudioLowerVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume -l 1.0 @DEFAULT_SINK@ 5%-";
        };
    };
    extraConfig = "corner_radius 10";
}
