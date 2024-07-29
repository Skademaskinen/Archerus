{pkgs, config, lib, nix-velocity, ...}: let
    cfg = config.minecraft;
in {
    minecraft = {
        servers = {
            hub = {
                server-port = 25566;
                force-gamemode = true;
                gamemode = "adventure";
                white-list = false;
                enforce-whitelist = false;
                online-mode = false;
                difficulty = "peaceful";
                bukkit.settings.allow-end = false;
                spigot.players.disable-saving = true;
                level-name = "hubworld";
                plugins = with nix-velocity.instances.plugins; [
                    decent-holograms
                    iportal-updated 
                    worldedit
                ];
            };
            #survival = {
            #    server-port = 25567;
            #    white-list = true;
            #    enforce-whitelist = true;
            #    online-mode = false;
            #    difficulty = "hard";
            #    plugins = {
            #        "CoreProtect.jar" = pkgs.fetchurl {
            #            url = "https://www.patreon.com/file?h=104200466&i=18902237";
            #            sha256 = "sha256-Ly+hxZU0SwcXakYfPlPhTqiEBxngkr7gUg1744CsPlU=";
            #        };
            #        "IPortal-Updated.jar" = pkgs.fetchurl {
            #            url = "https://github.com/JuL1En1997/Iportal/releases/download/major-update/Iportal-Updated-2.0.jar";
            #            sha256 = "sha256-uF4Izym8nvQVo8jhm41AG5re4RrUYUmVjFPsHIuBiyI=";
            #        };
            #        "Spark.jar" = pkgs.fetchurl {
            #            url = "https://www.spigotmc.org/resources/spark.57242/download?version=544173";
            #            sha256 = "sha256-CAesFNYfmrRhSMNkQOTfkjpiCpnhSkJ/Gb+kq0g5HGA=";
            #        };
            #    };
            #};
            modded = rec {
                server-port = 25567;
                white-list = true;
                enforce-whitelist = true;
                online-mode = false;
                difficulty = "hard";
                type = "fabric";
                version = "1.20.1";
                mods = with nix-velocity.instances.mods; [
                    servux
                    immersive-portals
                    fabric-api
                    fabric-proxy-lite
                    cross-stitch
                ];
            };
            creative = {
                server-port = 25568;
                white-list = true;
                enforce-whitelist = true;
                online-mode = false;
                difficulty = "hard";
                gamemode = "creative";
                type = "fabric";
                mods = with nix-velocity.instances.mods; [
                    servux
                    worldedit
                ];
            };
            paradox = {
                server-port = 25569;
                white-list = true;
                enforce-whitelist = true;
                online-mode = false;
                difficulty = "hard";
            };
        };
        fallback = "hub";
        motd = "<#ff5500>[Skademaskinen]<reset>                     <u><https://${config.skademaskinen.domain}></u>\n<rainbow>Minecraft";
        icon = ../../../files/icon.png;
    };
}
