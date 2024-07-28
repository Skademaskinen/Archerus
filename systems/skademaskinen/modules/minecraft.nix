{pkgs, config, lib, ...}: let
    cfg = config.skademaskinen.minecraft;
in {
    skademaskinen.minecraft = {
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
                plugins = {
                    "DecentHolograms.jar" = pkgs.fetchurl {
                        url = "https://github.com/DecentSoftware-eu/DecentHolograms/releases/download/2.8.9/DecentHolograms-2.8.9.jar";
                        sha256 = "sha256-rEV5rbPXA5WFPwU+K3XO0LMC2i0PvTA0SYtE/1wTMbA=";
                    };
                    "IPortal-Updated.jar" = pkgs.fetchurl {
                        url = "https://github.com/JuL1En1997/Iportal/releases/download/major-update/Iportal-Updated-2.0.jar";
                        sha256 = "sha256-uF4Izym8nvQVo8jhm41AG5re4RrUYUmVjFPsHIuBiyI=";
                    };
                    "WorldEdit.jar" = pkgs.fetchurl {
                        url = "https://cdn.modrinth.com/data/1u6JkXh5/versions/Jo76t1oi/worldedit-bukkit-7.3.5.jar";
                        sha256 = "sha256-xMIsPMKop0pNWThOFsiA0TTrwEotN4FYkpy+MF8ctSA=";
                    };
                };
            };
            survival = {
                server-port = 25567;
                white-list = true;
                enforce-whitelist = true;
                online-mode = false;
                difficulty = "hard";
                plugins = {
                    "CoreProtect.jar" = pkgs.fetchurl {
                        url = "https://www.patreon.com/file?h=104200466&i=18902237";
                        sha256 = "sha256-Ly+hxZU0SwcXakYfPlPhTqiEBxngkr7gUg1744CsPlU=";
                    };
                    "IPortal-Updated.jar" = pkgs.fetchurl {
                        url = "https://github.com/JuL1En1997/Iportal/releases/download/major-update/Iportal-Updated-2.0.jar";
                        sha256 = "sha256-uF4Izym8nvQVo8jhm41AG5re4RrUYUmVjFPsHIuBiyI=";
                    };
                    "Spark.jar" = pkgs.fetchurl {
                        url = "https://www.spigotmc.org/resources/spark.57242/download?version=544173";
                        sha256 = "sha256-CAesFNYfmrRhSMNkQOTfkjpiCpnhSkJ/Gb+kq0g5HGA=";
                    };

                };
            };
            creative = {
                server-port = 25568;
                white-list = true;
                enforce-whitelist = true;
                online-mode = false;
                difficulty = "hard";
                gamemode = "creative";
                type = "fabric";
                mods = {
                    "Servux.jar" = pkgs.fetchurl {
                        url = "https://cdn.modrinth.com/data/zQhsx8KF/versions/MBfJui8X/servux-fabric-1.21.0-0.2.0.jar";
                        sha256 = "sha256-td2eH5IDDH+7u22l1TNyBsiisMvvpMJXS00aOB0YtDY=";
                    };
                    "WorldEdit.jar" = pkgs.fetchurl {
                        url = "https://cdn.modrinth.com/data/1u6JkXh5/versions/srWerknn/worldedit-mod-7.3.5.jar";
                        sha256 = "sha256-dtJQ9DMZ2RqVlIzUwHRtydFdXpV3c7hDIZhB0ftsn3I=";
                    };
                };
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
