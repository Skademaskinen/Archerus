{pkgs, ...}: {
    imports = [./pipewire.nix];

    programs.sway = {
        enable = true;
        package = pkgs.swayfx;
        extraPackages = with pkgs; [
            gtklock
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
}
