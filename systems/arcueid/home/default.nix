{config, pkgs, ...}:

{
    imports = [
        ./sway
        ./alacritty.nix
        ./symlinks.nix
    ];
    home = {
        stateVersion = "24.11";
        packages = with pkgs; [
            dconf
            nixos-icons
            (import ../../../packages/bolt { inherit pkgs; })
            htop
            bottles
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

    programs.obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
            wlrobs
            obs-backgroundremoval
            obs-pipewire-audio-capture
        ];
    };

}
