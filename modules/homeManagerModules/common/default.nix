{ archerusPkgs, ... }:

{ pkgs, lib, ... }:

{
    options = {
        skade.desktop.battery = lib.mkOption {
            type = lib.types.bool;
            default = true;
        };
    };
    config = {
        gtk = {
            enable = true;
            cursorTheme.name = "Adwaita";
            cursorTheme.package = pkgs.vimix-cursors;
            
            font.name = "LigaComicMono, 10";
            font.package = archerusPkgs.comicMonoLiga;
            iconTheme.name = "breeze-dark";
            iconTheme.package = pkgs.kdePackages.breeze;
            theme.name = "Adwaita-dark";
            theme.package = pkgs.gnome-themes-extra;
        };
        qt = {
            enable = true;
            platformTheme.name = "gtk";
        };

        home.packages = with pkgs; [
            cinny-desktop
            bat
            archerusPkgs.electronApps.chatgpt
            archerusPkgs.electronApps.youtube
            archerusPkgs.electronApps.stregsystemet
            archerusPkgs.electronApps.fikien
            archerusPkgs.electronApps.nixosSearch
        ];
        services.swaync = {
            enable = true;
            style = builtins.readFile ../common/nwg/swaync.css;
        };
    };
}
