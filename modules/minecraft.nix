{config, lib, pkgs, ... }: let
    cfg = config.skademaskinen.minecraft;
    prefix = "${config.skademaskinen.storage}/minecraft";

    paper-wrapped = import ./minecraft/paper.nix { inherit config pkgs; };
    velocity-wrapped = import ./minecraft/velocity.nix { inherit config pkgs; };
    tools = import ./minecraft/options/tools.nix { lib = lib; };
in with tools; {
    options.skademaskinen.minecraft = with lib.types; {
        servers = lib.mkOption {
            type = attrsOf (submodule {
                options = {
                    accepts-transfers = fbool;
                    allow-flight = fbool;
                    allow-nether = tbool;
                    broadcast-console-to-ops = tbool;
                    broadcast-rcon-to-ops = tbool;
                    debug = fbool;
                    difficulty = stropt "easy";
                    enable-command-block = fbool;
                    enable-jmx-monitoring = fbool;
                    enable-query = fbool;
                    enable-rcon = fbool;
                    enable-status = tbool;
                    enforce-secure-profile = fbool;
                    enforce-whitelist = fbool;
                    entity-broadcast-range-percentage = intopt 100;
                    force-gamemode = fbool;
                    function-permission-level = intopt 2;
                    gamemode = stropt "survival";
                    generate-structures = tbool;
                    hardcore = fbool;
                    hide-online-players = fbool;
                    initial-enabled-packs = stropt "vanilla";
                    level-name = stropt "world";
                    level-seed = stropt "";
                    level-type = stropt "minecraft\\:normal";
                    log-ips = tbool;
                    max-chained-neighbor-updates = intopt 1000000;
                    max-players = intopt 20;
                    max-tick-time = intopt 60000;
                    max-world-size = intopt 29999984;
                    motd = stropt "A Minecraft Server";
                    network-compression-threshold = intopt 256;
                    online-mode = fbool;
                    op-permission-level = intopt 4;
                    player-idle-timeout = intopt 0;
                    prevent-proxy-connections = fbool;
                    pvp = tbool;
                    query.port = intopt 25566;
                    rate-limit = intopt 0;
                    rcon.password = stropt "";
                    rcon.port = intopt 25575;
                    region-file-compression = stropt "deflate";
                    require-resource-pack = fbool;
                    server-ip = stropt "";
                    server-port = intopt 25566;
                    simulation-distance = intopt 10;
                    spawn-animals = tbool;
                    spawn-monsters = tbool;
                    spawn-npcs = tbool;
                    spawn-protection = intopt 16;
                    sync-chunk-writes = tbool;
                    use-native-transport = tbool;
                    view-distance = intopt 10;
                    white-list = fbool;
                    spigot = import ./minecraft/options/spigot.nix { inherit lib; };
                    bukkit = import ./minecraft/options/bukkit.nix { inherit lib; };
                    paper-global = import ./minecraft/options/paper-global.nix { inherit lib; };
                    #paper-world = import ./minecraft/options/paper-world.nix { inherit lib; };
                };
            });
            default = {};
        };
        fallback = stropt "";
        secret = stropt "velocity-secret";
        icon = lib.mkOption {
            type = path;
            default = null;
        };
        motd = stropt "<rainbow>Minecraft server";
        port = intopt 25565;
        version = stropt "2.7";
        max-players = intopt 500;
        online-mode = tbool;
        force-key-authentication = fbool;
        prevent-client-proxy-connections = fbool;
        player-info-forwarding-mode = stropt "modern";
        announce-forge = fbool;
        kick-existing-players = fbool;
        ping-passthrough = stropt "disabled";
        enable-player-address-logging = tbool;
        advanced = {
            compression-threshold = intopt 256;
            compression-level = intopt (-1);
            login-ratelimit = intopt 3000;
            connection-timeout = intopt 5000;
            read-timeout = intopt 30000;
            haproxy-protocol = fbool;
            tcp-fast-open = fbool;
            bungee-plugin-message-channel = tbool;
            show-ping-requests = fbool;
            failover-on-unexpected-server-disconnect = tbool;
            announce-proxy-commands = tbool;
            log-command-executions = fbool;
            log-player-connections = tbool;
            accepts-transfers = fbool;

        };
        query = {
            enabled = fbool;
            port = intopt 25577;
            map = stropt "Velocity";
            show-plugins = fbool;
        };
    };

    config = {
        systemd.services = let 
            velocity = {
                enable = true;
                serviceConfig = {
                    ExecStart = "${pkgs.bash}/bin/bash ${velocity-wrapped}/bin/velocity-wrapped";
                };
                wantedBy = ["default.target"];
            };
        in if (builtins.length (builtins.attrNames cfg.servers)) > 0 then pkgs.lib.mergeAttrs {velocity = velocity;} (builtins.mapAttrs (name: server: {
            enable = true;
            serviceConfig = {
                ExecStart = "${pkgs.bash}/bin/bash ${paper-wrapped (pkgs.lib.mergeAttrs {name = name;} server)}/bin/paper-wrapped";
            };
            wantedBy = ["default.target"];
        }) cfg.servers) else {};
    };
}
