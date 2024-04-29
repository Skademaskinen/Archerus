{pkgs, home-manager, ...}: {
    imports = [./pipewire.nix];

    programs.sway = {
        enable = true;
        package = pkgs.swayfx;
        extraPackages = with pkgs; [
            gtklock
            rofi
            konsole
            hack-font
            dunst
            swaybg
            mpvpaper
            font-awesome
            eww
            grim
            wl-clipboard
            slurp
            source-code-pro
            jq
            alsa-utils
        ];
    };
    xdg.portal.wlr.enable = true;

}
