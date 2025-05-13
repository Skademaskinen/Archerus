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
            ];
            exec-once = [
                "${pkgs.callPackage ./common/nwg/panel.nix {}}"
                "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"
            ];
            general = {
                "col.active_border" = "rgba(#ff5500)";
                "col.inactive_border" = "rgba(#595959)";
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
