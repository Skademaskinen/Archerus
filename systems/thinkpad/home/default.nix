{ pkgs, ... }:

{
    imports = [
        ./sway
        ./alacritty.nix
    ];
    home = {
        stateVersion = "24.11";
        packages = with pkgs; [
            dconf
            nixos-icons
            (import ../../../packages/bolt { inherit pkgs; })
            htop
            (writeScriptBin "p10-postgres" ''
                #!${bash}/bin/bash
                ${docker}/bin/docker compose -f ${writeText "docker-compose.json" (lib.strings.toJSON {
                    services.db = {
                        image = "postgres";
                        environment = {
                            POSTGRES_USER = "root";
                            POSTGRES_DB = "autoscaler";
                            POSTGRES_PASSWORD = "password";
                        };
                        ports = [
                            "5432:5432"
                        ];
                        volumes = [
                            "/var/postgres_data:/var/lib/postgresql/data"
                        ];
                    };
                })} $@
                if test "$1" = "up"; then
                    ${dotnet-sdk_8}/bin/dotnet run --project ~/git/p10/Autoscaler/Autoscaler.DbUp
                fi
            '')
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
