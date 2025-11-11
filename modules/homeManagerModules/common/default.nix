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
            cursorTheme.package = pkgs.adwaita-icon-theme;
            
            #font.name = "LigaComicMono, 10";
            font.name = "FiraCode Nerd Font Mono Medium, 10";
            #font.package = archerusPkgs.comicMonoLiga;
            font.package = pkgs.nerd-fonts.fira-mono;
            iconTheme.name = "Papirus-Dark";
            iconTheme.package = pkgs.papirus-icon-theme;
            theme.name = "Adwaita-dark";
            theme.package = pkgs.gnome-themes-extra;
        };
        qt = {
            enable = true;
            platformTheme.name = "gtk";
        };

        home.packages = with pkgs; [
            bat
            archerusPkgs.electronApps.chatgpt
            archerusPkgs.electronApps.youtube
            archerusPkgs.electronApps.stregsystemet
            archerusPkgs.electronApps.fikien
            archerusPkgs.electronApps.nixosSearch
        ];
    };
}
