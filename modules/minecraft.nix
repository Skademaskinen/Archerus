{lib, pkgs, config, ... }: let
    prefix = "/mnt/raid/minecraft";
    paperSource = pkgs.fetchurl {
        url = "https://api.papermc.io/v2/projects/paper/versions/1.20.4/builds/450/downloads/paper-1.20.4-450.jar";
        sha256 = "sha256-SHqHHe0+utxdv2wfZOeikBNATfcHVJ5fMEL4jPXmopU=";
    };
    waterfallSource = pkgs.fetchurl {
        url = "https://api.papermc.io/v2/projects/waterfall/versions/1.20/builds/565/downloads/waterfall-1.20-565.jar";
        sha256 = "sha256-PSdqP1f4UDx+VIhZ0PxrxBfZZyEW2fp+6wD3YQcH1vo=";
    };


    makeServer = {waterfall ? false, name}: {
        enable = true;
        description = "Minecraft ${name} Service";
        serviceConfig = {
            WorkingDirectory = "${prefix}/${name}";
            ExecStart = if waterfall
                then "${pkgs.jdk}/bin/java -jar ${waterfallSource}"
                else "${pkgs.jdk}/bin/java -jar ${paperSource}";
            Restart = "on-failure";
            StandardInput = "socket";
            StandardOutput = "journal";
            StandardError = "journal";
            Sockets = "minecraft-${name}.socket";
        };
        wantedBy = [ "default.target" ];
    };
    makeServers = (names: lib.listToAttrs (lib.concatLists [
        (map (name: { name = "minecraft-${name}"; value = makeServer { name = name; }; }) names) 
        (if names != [] then [{name = "minecraft-waterfall"; value = makeServer {name = "waterfall"; waterfall = true;}; }] else [])
    ]));

    makeSocket = name: {
        enable = true;
        description = "Minecraft ${name} STDIN socket";
        socketConfig = {
            ListenFIFO = "${prefix}/${name}/${name}.stdin";
            Service = "minecraft-${name}.service";
            User = "minecraft";
        };
    };
    makeSockets = (names: lib.listToAttrs (lib.concatLists [
        (map (name: { name = "minecraft-${name}"; value = makeSocket name; }) names)
        (if names != [] then [{ name = "minecraft-waterfall"; value = makeSocket "waterfall"; }] else [])
    ]));

in {
    options = {
        skademaskinen.minecraft-servers = lib.mkOption {
            type = pkgs.lib.types.listOf pkgs.lib.types.str;
            default = [];
        };
    };
    config = {
        users.users.minecraft = {
            isSystemUser = true;
            description = "minecraft server manager";
            group = "minecraft";
            packages = with pkgs; [ openjdk screen wget ];
        };
        users.groups.minecraft = { };

        systemd.services = makeServers config.skademaskinen.minecraft-servers;
        systemd.sockets = makeSockets config.skademaskinen.minecraft-servers;
    };
    
}
