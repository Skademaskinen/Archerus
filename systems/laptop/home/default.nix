{config, pkgs, ...}:

{
    imports = [
        ./sway
    ];
    home = {
        stateVersion = "24.11";
        packages = with pkgs; [
            dconf
            nixos-icons
        ];
    };
    
    gtk = {
        enable = true;
        cursorTheme.name = "Vimix-cursors";
        cursorTheme.package = pkgs.vimix-cursors;
        font.name = "Noto Sans, 10";
        font.package = pkgs.noto-fonts;
        iconTheme.name = "breeze-dark";
        iconTheme.package = pkgs.kdePackages.breeze;
        theme.name = "Adwaita-dark";
        theme.package = pkgs.gnome-themes-extra;
    };
    qt = {
        enable = true;
        platformTheme.name = "gtk";
    };
    
}
