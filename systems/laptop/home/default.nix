{config, pkgs, ...}:

{
    imports = [
        ./sway
    ];
    home = {
        stateVersion = "24.11";
        packages = with pkgs; [
            dconf
        ];
    };
    gtk = {
        enable = true;
        cursorTheme.name = "Vimix-cursors";
        cursorTheme.package = pkgs.vimix-cursors;
        font.name = "Fira Sans 10";
        font.package = pkgs.fira;
        iconTheme.name = "Adwaita-dark";
        iconTheme.package = pkgs.gnome-themes-extra;
        theme.name = "Adwaita-dark";
        theme.package = pkgs.gnome-themes-extra;
    };
    qt = {
        enable = true;
        platformTheme.name = "gtk";
    };
}
