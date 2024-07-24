{config, lib, pkgs, ... }: let
    prefix = "${config.skademaskinen.storage}/minecraft";
    paper = pkgs.fetchurl {
        url = "https://api.papermc.io/v2/projects/paper/versions/1.21/builds/109/downloads/paper-1.21-109.jar";
        sha256 = "sha256-dsYGExSUEl8GTcLtQBuUbUoS4IvwzNvzLtqgi2Yzwwo=";
    };
    velocity = pkgs.fetchurl {
        url = "https://api.papermc.io/v2/projects/velocity/versions/3.3.0-SNAPSHOT/builds/412/downloads/velocity-3.3.0-SNAPSHOT-412.jar";
        sha256 = "sha256-KOBsdASYlUxf2np87DK3KnSHFM5hMjPqdYD2Ati8yIQ=";
    };


    makeServer = {waterfall ? false, name}: {
        enable = true;
        description = "Minecraft ${name} Service";
        serviceConfig = {
            WorkingDirectory = "${prefix}/${name}";
            ExecStart = if waterfall
                then "${pkgs.jdk21}/bin/java -jar ${velocity}"
                else "${pkgs.jdk21}/bin/java -jar ${paper}";
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
        (if names != [] then [{name = "minecraft-velocity"; value = makeServer {name = "velocity"; waterfall = true;}; }] else [])
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
        (if names != [] then [{ name = "minecraft-velocity"; value = makeSocket "velocity"; }] else [])
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
