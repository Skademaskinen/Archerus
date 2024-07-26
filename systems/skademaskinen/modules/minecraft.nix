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
                plugins = {
                    "DecentHolograms.jar" = pkgs.fetchurl {
                        url = "https://github.com/DecentSoftware-eu/DecentHolograms/releases/download/2.8.9/DecentHolograms-2.8.9.jar";
                        sha256 = "sha256-rEV5rbPXA5WFPwU+K3XO0LMC2i0PvTA0SYtE/1wTMbA=";
                    };
                    "IPortal-Updated.jar" = pkgs.fetchurl {
                        url = "https://github.com/JuL1En1997/Iportal/releases/download/major-update/Iportal-Updated-2.0.jar";
                        sha256 = "sha256-uF4Izym8nvQVo8jhm41AG5re4RrUYUmVjFPsHIuBiyI=";
                    };
                    #"WorldEdit.jar" = pkgs.fetchurl {
                    #    url = "https://dev.bukkit.org/projects/worldedit/files/5564367";
                    #    sha256 = "sha256-Px0Va1uRLmQKve76NlIYthvSSlAgelh5KPPHi7dpi7o=";
                    #};
                    #"WorldGuard.jar" = pkgs.fetchurl {
                    #    url = "https://dev.bukkit.org/projects/worldguard/files/5344377";
                    #    sha256 = "sha256-O3flXyIBI5uo9AFhOcGdpMS94yDvvOnMt81b/tVu5oM=";
                    #};
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
                    #"WorldEdit.jar" = pkgs.fetchurl {
                    #    url = "https://dev.bukkit.org/projects/worldedit/files/5564367";
                    #    sha256 = "sha256-Px0Va1uRLmQKve76NlIYthvSSlAgelh5KPPHi7dpi7o=";
                    #};
                };
            };
            creative = {
                server-port = 25568;
                white-list = true;
                enforce-whitelist = true;
                online-mode = false;
                difficulty = "hard";
                gamemode = "creative";
                plugins = {
                    "tabtps.jar" = pkgs.fetchurl {
                        url = "https://www.spigotmc.org/resources/tabtps-1-8-8-1-21-show-tps-mspt-and-more-in-the-tab-menu.82528/download?version=546554";
                        sha256 = "sha256-SuoV7C0uo61x3gT6LE7Zy3OrNj+pGQaiJ4qCfjabN3c=";
                    };
                    #"WorldEdit.jar" = pkgs.fetchurl {
                    #    url = "https://dev.bukkit.org/projects/worldedit/files/5564367";
                    #    sha256 = "sha256-Px0Va1uRLmQKve76NlIYthvSSlAgelh5KPPHi7dpi7o=";
                    #};

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
        motd = "<#ff5500>Skademaskinen Declarative <rainbow>Minecraft <#ff5500>server";
        icon = ../../../files/icon.png;
    };
}