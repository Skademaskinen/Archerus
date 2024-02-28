{ config, lib, pkgs, modulesPath, ... }: {

    users.users.minecraft = {
        isSystemUser = true;
        description = "minecraft server manager";
        group = "minecraft";
        packages = with pkgs; [ openjdk screen wget ];
    };
    users.groups.minecraft = { };

    systemd.services.minecraft-waterfall = {
        enable = true;
        description = "minecraft waterfall service";
        serviceConfig = {
            WorkingDirectory = "/mnt/raid/minecraft/waterfall";
            User = "minecraft";
            ExecStart =
                "${pkgs.jdk}/bin/java -jar /mnt/raid/minecraft/waterfall/waterfall.jar";
            Restart = "on-failure";
            StandardInput = "socket";
            StandardOutput = "journal";
            StandardError = "journal";
            Sockets = "minecraft-waterfall.socket";
        };
        wantedBy = [ "default.target" ];
    };

    systemd.services.minecraft-survival = {
        enable = true;
        description = "minecraft survival service";
        serviceConfig = {
            WorkingDirectory = "/mnt/raid/minecraft/survival";
            User = "minecraft";
            ExecStart =
                "${pkgs.jdk}/bin/java -jar /mnt/raid/minecraft/survival/survival.jar";
            Restart = "on-failure";
            StandardInput = "socket";
            StandardOutput = "journal";
            StandardError = "journal";
            Sockets = "minecraft-survival.socket";
        };
        wantedBy = [ "default.target" ];
    };

    systemd.services.minecraft-hub = {
        enable = true;
        description = "minecraft hub service";
        serviceConfig = {
            WorkingDirectory = "/mnt/raid/minecraft/hub";
            User = "minecraft";
            ExecStart = "${pkgs.jdk}/bin/java -jar /mnt/raid/minecraft/hub/hub.jar";
            Restart = "on-failure";
            StandardInput = "socket";
            StandardOutput = "journal";
            StandardError = "journal";
            Sockets = "minecraft-hub.socket";
        };
        wantedBy = [ "default.target" ];
    };

    systemd.services.minecraft-creative = {
        enable = true;
        description = "minecraft creative service";
        serviceConfig = {
            WorkingDirectory = "/mnt/raid/minecraft/creative";
            User = "minecraft";
            ExecStart =
                "${pkgs.jdk}/bin/java -jar /mnt/raid/minecraft/creative/creative.jar";
            Restart = "on-failure";
            StandardInput = "socket";
            StandardOutput = "journal";
            StandardError = "journal";
            Sockets = "minecraft-creative.socket";
        };
        wantedBy = [ "default.target" ];
    };

    systemd.services.minecraft-paradox = {
        enable = true;
        description = "Minecraft paradox service";
        serviceConfig = {
            WorkingDirectory = "/mnt/raid/minecraft/paradox";
            User = "minecraft";
            ExecStart =
                "${pkgs.jdk}/bin/java -jar /mnt/raid/minecraft/paradox/paradox.jar";
            Restart = "on-failure";
            StandardInput = "socket";
            StandardOutput = "journal";
            StandardError = "journal";
            Sockets = "minecraft-paradox.socket";
        };
        wantedBy = [ "default.target" ];
    };

    systemd.sockets.minecraft-waterfall = {
        enable = true;
        description = "Minecraft waterfall STDIN socket";
        socketConfig = {
            ListenFIFO = "%t/waterfall.stdin";
            Service = "minecraft-waterfall.service";
            User = "minecraft";
        };
    };

    systemd.sockets.minecraft-survival = {
        enable = true;
        description = "Minecraft survival STDIN socket";
        socketConfig = {
            ListenFIFO = "%t/survival.stdin";
            Service = "minecraft-survival.service";
            User = "minecraft";
        };
    };

    systemd.sockets.minecraft-hub = {
        enable = true;
        description = "Minecraft hub STDIN socket";
        socketConfig = {
            ListenFIFO = "%t/hub.stdin";
            Service = "minecraft-hub.service";
            User = "minecraft";
        };
    };

    systemd.sockets.minecraft-creative = {
        enable = true;
        description = "Minecraft creative STDIN socket";
        socketConfig = {
            ListenFIFO = "%t/creative.stdin";
            Service = "minecraft-creative.service";
            User = "minecraft";
        };
    };

    systemd.sockets.minecraft-paradox = {
        enable = true;
        description = "Minecraft paradox STDIN socket";
        socketConfig = {
            ListenFIFO = "%t/paradox.stdin";
            Service = "minecraft-paradox.service";
            User = "minecraft";
        };
    };
}   
