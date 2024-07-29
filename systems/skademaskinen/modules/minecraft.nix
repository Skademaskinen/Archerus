{pkgs, config, lib, ...}: let
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
            modded = {
                server-port = 25567;
                white-list = true;
                enforce-whitelist = true;
                online-mode = false;
                difficulty = "hard";
                type = "fabric";
                mods = {
                    "Servux.jar" = pkgs.fetchurl {
                        url = "https://cdn.modrinth.com/data/zQhsx8KF/versions/I7wfvH49/servux-fabric-1.20.0-0.1.0.jar";
                        sha256 = "sha256-zUsjuD2tQKcLPHU1rdx24Wbp6vguH7CLOeDwPrzj0H0=";
                    };
                    "Immersive-Portals.jar" = pkgs.fetchurl {
                        url = "https://cdn.modrinth.com/data/zJpHMkdD/versions/155jtqJi/immersive-portals-3.3.9-mc1.20.1-fabric.jar";
                        sha256 = "sha256-vrNfdLmLU3t7V3Q7aFT88ZAAqabZP2EfZJQBOD5mAE4=";
                    };
                    "Fabric-API.jar" = pkgs.fetchurl {
                        url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/P7uGFii0/fabric-api-0.92.2%2B1.20.1.jar";
                        sha256 = "sha256-RQD4RMRVc9A51o05Y8mIWqnedxJnAhbgrT5d8WxncPw=";
                    };
                    "CrossStitch.jar" = pkgs.fetchurl {
                        url = "https://cdn.modrinth.com/data/YkOyn1Pn/versions/dJioNlO8/crossstitch-0.1.6.jar";
                        sha256 = "sha256-z1qsXFV5sc6xsr0loV8eLcySJvV2cBY60fhBsvkFuC4=";
                    };

                };
                jars.fabric = pkgs.fetchurl {
                    url = "https://meta.fabricmc.net/v2/versions/loader/1.20.1/0.15.11/1.0.1/server/jar";
                    sha256 = "sha256-/j9wIzYSoP+ZEfeRJSsRwWhhTNkTMr+vN40UX9s+ViM=";
                };
                jars.fabric-proxy-lite = pkgs.fetchurl {
                    url = "https://cdn.modrinth.com/data/8dI2tmqs/versions/XJmDAnj5/FabricProxy-Lite-2.6.0.jar";
                    sha256 = "sha256-1HGReTU9eQRTBhwUtBSJlP9DGsV6EmVVswCc6adI1sc=";
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
