inputs:

{ pkgs, ... }: let
    wallpaper = pkgs.fetchurl inputs.self.lib.wallpapers.arcueid;
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
                "$mod, 1, workspace, 1"
                "$mod, 2, workspace, 2"
                "$mod, 3, workspace, 3"
                "$mod, 4, workspace, 4"
                "$mod, 5, workspace, 5"
                "$mod, 6, workspace, 6"
                "$mod, 7, workspace, 7"
                "$mod, 8, workspace, 8"
                "$mod, 9, workspace, 9"
                "$mod, 0, workspace, 10"
            ];
            exec-once = [
                "${pkgs.callPackage ./common/nwg/panel-hyprland.nix {}}"
                "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"
            ];
            general = {
                "col.active_border" = "rgba(#ff5500ff)";
                "col.inactive_border" = "rgba(#595959ff)";
                gaps_in = "5";
                gaps_out = "10";
                border_size = "4";
            };

            decoration = {
                rounding = "5";
            };

            input = {
                kb_layout = "dk";
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
