{ pkgs, system, nix-minecraft, ... }:

let
    servers = nix-minecraft.legacyPackages.${system};
    secret = "velocity-secret";

    proxies = {
        velocity = {
            inherit secret;
            enabled = true;
            online-mode = true;
        };
    };
    whitelist = {
        mast3r_waf1z = "cb7971ff-7089-429b-ad5f-609ffbcd2ddb";
        Power_Supply = "010e5ef3-a1fb-4c2e-819c-35c96285fc1e";
    };
    ops = {
        uuid = "cb7971ff-7089-429b-ad5f-609ffbcd2ddb";
        name = "mast3r_waf1z";
        level = 4;
        bypassesPlayerLimit = true;
    };
in

{ config, ... }:

{
    imports = [
        nix-minecraft.nixosModules.minecraft-servers
    ];

    services.minecraft-servers = {
        enable = true;
        eula = true;
        openFirewall = true;

        managementSystem.systemd-socket = {
            enable = true;
            stdinSocket.path = name: "${config.skade.projectsRoot}/sockets/minecraft-${name}.stdin";
        };

        servers = {

/*
    --- VELOCITY ---
*/
            velocity = {
                enable = true;
                package = servers.velocityServers.velocity-3_4_0-SNAPSHOT-build_551;
                files = {
                    "velocity.toml".value = {
                        config-version = "2.7";
                        bind = "0.0.0.0:25565";
                        motd = "<<#ff5500>${config.networking.hostName} <reset>>                       <u>https://${config.skade.baseDomain}</u>
                        Minecraft";
                        show-max-players = 50;
                        online-mode = true;
                        force-key-authentication = true;
                        prevent-client-proxy-connections = false;
                        player-info-forwarding-mode = "modern";
                        forwarding-secret-file = pkgs.writeText "velocity-forwarding-secret" secret;
                        announce-forge = false;
                        kick-existing-players = false;
                        ping-passthrough = "disabled";
                        enable-player-address-logging = true;
                        servers = {
                            lobby = "127.0.0.1:25570";
                            survival = "127.0.0.1:25571";
                            modded = "127.0.0.1:25572";
                            try = [
                                "lobby"
                            ];
                        };
                        forced-hosts = {
                            "lobby.${config.skade.baseDomain}" = [
                                "lobby"
                            ];
                            "survival.${config.skade.baseDomain}" = [
                                "survival"
                            ];
                            "modded.${config.skade.baseDomain}" = [
                                "modded"
                            ];
                        };
                        advanced = {
                            compression-threshold = 256;
                            compression-level = -1;
                            login-ratelimit = 3000;
                            connection-timeout = 5000;
                            read-timeout = 30000;
                            haproxy-protocol = false;
                            tcp-fast-open = false;
                            bungee-plugin-message-channel = true;
                            show-ping-requests = false;
                            failover-on-unexpected-server-disconnect = true;
                            announce-proxy-commands = true;
                            log-command-executions = false;
                            log-player-connections = true;
                            accepts-transfers = false;
                        };
                        query = {
                            enabled = false;
                            port = 25565;
                            map = "Velocity";
                            show-plugins = false;
                        };
                    };
                };
            };

/*
    --- LOBBY ---
*/

            lobby = {
                inherit whitelist;
                enable = true;
                package = servers.paperServers.paper-1_20_1;

                serverProperties = {
                    server-port = 25570;
                    online-mode = false;
                    gamemode = "adventure";
                    allow-nether = false;
                    difficulty = "peaceful";
                    pvp = false;
                    spawn-animals = false;
                    spawn-monsters = false;
                    spawn-npcs = false;
                    spawn-protection = 256;
                    simulation-distance = 8;
                    view-distance = 20;
                    enforce-whitelist = true;
                    white-list = true;
                };
                files = {
                    "ops.json".value = ops;
                    "config/paper-global.yml".value = {
                        inherit proxies;
                    };
                };
                symlinks = {
                    "plugins/decent-holograms.jar" = pkgs.fetchurl {
                        url = "https://github.com/DecentSoftware-eu/DecentHolograms/releases/download/2.8.9/DecentHolograms-2.8.9.jar";
                        sha256 = "sha256-rEV5rbPXA5WFPwU+K3XO0LMC2i0PvTA0SYtE/1wTMbA=";
                    };
                    "plugins/stargate.jar" = pkgs.fetchurl {
                        url = "https://cdn.modrinth.com/data/kS8Pugaw/versions/Moh1fu3y/Stargate-0.11.5.10.jar";
                        sha256 = "sha256-hoqfEsDCML8EULlBp3hNOJhPUIdZKDNk4lTi5fDqVlw=";
                    };
                };
            };

/*
    --- SURVIVAL ---
*/

            survival = {
                inherit whitelist;
                enable = true;
                package = servers.paperServers.paper-1_20_1;

                serverProperties = {
                    server-port = 25571;
                    online-mode = false;
                    gamemode = "survival";
                    allow-nether = false;
                    difficulty = "hard";
                    pvp = false;
                    spawn-animals = false;
                    spawn-monsters = false;
                    spawn-npcs = false;
                    spawn-protection = 256;
                    simulation-distance = 8;
                    view-distance = 20;
                    enforce-whitelist = true;
                    white-list = true;
                };
                files = {
                    "ops.json".value = ops;
                    "config/paper-global.yml".value = {
                        inherit proxies;
                    };
                };

            };

/*
    --- MODDED ---
*/

            modded = {
                inherit whitelist;
                enable = true;
                package = servers.fabricServers.fabric-1_20_1;

                serverProperties = {
                    server-port = 25572;
                    online-mode = false;
                    gamemode = "survival";
                    allow-nether = false;
                    difficulty = "hard";
                    pvp = false;
                    spawn-animals = false;
                    spawn-monsters = false;
                    spawn-npcs = false;
                    spawn-protection = 256;
                    simulation-distance = 8;
                    view-distance = 20;
                    enforce-whitelist = true;
                    white-list = true;
                };
                files = {
                    "ops.json".value = ops;
                    "config/paper-global.yml".value = {
                        inherit proxies;
                    };
                    "config/FabricProxy-Lite.toml".value = {
                        inherit secret;
                        # these option names sound so edgy...
                        hackOnlineMode = false;
                        hackEarlySend = false;
                        hackMessageChain = true;
                    };
                };

                symlinks = {
                    "mods/create.jar" = pkgs.fetchurl {
                        url = "https://cdn.modrinth.com/data/Xbc0uyRg/versions/7Ub71nPb/create-fabric-0.5.1-j-build.1631%2Bmc1.20.1.jar";
                        sha256 = "sha256-M+wdaWxofpXN7Qz/ptWBrIC8nkFuxgQPzVlc4ibXC/s=";
                    };
                    "mods/create-structures.jar" = pkgs.fetchurl {
                        url = "https://cdn.modrinth.com/data/IAnP4np7/versions/nqsTHZwx/create-structures-0.1.1-1.20.1-FABRIC.jar";
                        sha256 = "sha256-MWejoAIy4RXqtK/asnfi0MTSnIv2jHe1e1MozMudtPY=";
                    };
                    "mods/create-steam-n-rails.jar" = pkgs.fetchurl {
                        url = "https://cdn.modrinth.com/data/ZzjhlDgM/versions/VFhdqLko/Steam_Rails-1.6.9%2Bfabric-mc1.20.1.jar";
                        sha256 = "sha256-OPNfo2wWiPEp98K07MdBq9D+0SrZlvI7WOFegWKYXOU=";
                    };
                    "mods/createaddition.jar" = pkgs.fetchurl {
                        url = "https://cdn.modrinth.com/data/kU1G12Nn/versions/ybLiaryg/createaddition-fabric%2B1.20.1-1.2.6.jar";
                        sha256 = "sha256-L1/j/03RHo+Mf0tPQW7Rz/iWSdBb7O+nGTCgCT0rsh8=";
                    };
                    "mods/createoreexcavation.jar" = pkgs.fetchurl {
                        url = "https://cdn.modrinth.com/data/ResbpANg/versions/O48L7huv/createoreexcavation-fabric-1.20-1.5.4.jar";
                        sha256 = "sha256-JhpCQ8xZmkRKNHVf0SAADunI1fgQfhlac1ot+EN7cRw=";
                    };
                    "mods/createnuclear.jar" = pkgs.fetchurl {
                        url = "https://cdn.modrinth.com/data/z611fdf7/versions/inOwpH0J/createnuclear-1.3.0-fabric.jar";
                        sha256 = "sha256-w0j+GueJGQ0AtgFD/JE4XsHZov7dH9PhfvEV9Gnb4aQ=";
                    };
                    "mods/createnewage.jar" = pkgs.fetchurl {
                        url = "https://cdn.modrinth.com/data/FTeXqI9v/versions/rk63oafd/create-new-age-fabric-1.20.1-1.1.2.jar";
                        sha256 = "sha256-egBYEdjonRJCE5NuR/XyAN8u3m3aDjyVjVtvm0vJb1o=";
                    };
                    #"mods/refinedstorage.jar" = pkgs.fetchurl {
                    #    url = "https://cdn.modrinth.com/data/KDvYkUg3/versions/eWiykVl5/refinedstorage-fabric-2.0.0-beta.1.jar";
                    #    sha256 = "sha256-DgYblnb2KRvtyyg/R9eeELr14eFkPY8W6PrMofO/ZHY=";
                    #};
                    "mods/create-enchantment-industry.jar" = pkgs.fetchurl {
                        url = "https://cdn.modrinth.com/data/AEZO385x/versions/SI0RzkGk/create_enchantment_industry-1.2.16.jar";
                        sha256 = "sha256-MOjqwuxtY9XNR5QML6kS4C+aj9muROs7gCZt/qZCYak=";
                    };
                    "mods/botarium.jar" = pkgs.fetchurl {
                        url = "https://cdn.modrinth.com/data/2u6LRnMa/versions/f3ATcSfq/botarium-fabric-1.20.1-2.3.4.jar";
                        sha256 = "sha256-2CkgC127Rklw4si5E+OXiP2JAuQ8QBggDYWAgztNAyQ=";
                    };
                    "mods/fabric-proxy-lite.jar" = pkgs.fetchurl {
                        url = "https://cdn.modrinth.com/data/8dI2tmqs/versions/XJmDAnj5/FabricProxy-Lite-2.6.0.jar";
                        sha256 = "sha256-1HGReTU9eQRTBhwUtBSJlP9DGsV6EmVVswCc6adI1sc=";
                    };
                    "mods/fabric-api.jar" = pkgs.fetchurl {
                        url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/P7uGFii0/fabric-api-0.92.2%2B1.20.1.jar";
                        sha256 = "sha256-RQD4RMRVc9A51o05Y8mIWqnedxJnAhbgrT5d8WxncPw=";
                    };
                    "mods/servux.jar" = pkgs.fetchurl {
                        url = "https://cdn.modrinth.com/data/zQhsx8KF/versions/I7wfvH49/servux-fabric-1.20.0-0.1.0.jar";
                        sha256 = "sha256-zUsjuD2tQKcLPHU1rdx24Wbp6vguH7CLOeDwPrzj0H0=";
                    };
                    #"mods/worldedit.jar" = pkgs.fetchurl {
                    #    url = "https://cdn.modrinth.com/data/1u6JkXh5/versions/srWerknn/worldedit-mod-7.3.5.jar";
                    #    sha256 = "sha256-dtJQ9DMZ2RqVlIzUwHRtydFdXpV3c7hDIZhB0ftsn3I=";
                    #};
                    "mods/immersive-portals.jar" = pkgs.fetchurl {
                        url = "https://cdn.modrinth.com/data/zJpHMkdD/versions/155jtqJi/immersive-portals-3.3.9-mc1.20.1-fabric.jar";
                        sha256 = "sha256-vrNfdLmLU3t7V3Q7aFT88ZAAqabZP2EfZJQBOD5mAE4=";
                    };
                    "mods/cross-stitch.jar" = pkgs.fetchurl {
                        url = "https://cdn.modrinth.com/data/YkOyn1Pn/versions/dJioNlO8/crossstitch-0.1.6.jar";
                        sha256 = "sha256-z1qsXFV5sc6xsr0loV8eLcySJvV2cBY60fhBsvkFuC4=";
                    };
                    #"mods/dynmap.jar" = pkgs.fetchurl {
                    #    url = "https://cdn.modrinth.com/data/fRQREgAc/versions/ipBhc6VW/Dynmap-3.7-beta-6-fabric-1.21.jar";
                    #    sha256 = "sha256-zcNNfJkuQTW3WCh4peU94P7KasGNBoma4FyrOH0BYfw=";
                    #};
                };
            };
        };
        dataDir = "${config.skade.projectsRoot}/projects/minecraft";
        
    };
    virtualisation.vmVariant.virtualisation.forwardPorts = [
        {
            from = "host";
            host.port = 25565;
            guest.port = 25565;
        }
        {
            from = "host";
            host.port = 25570;
            guest.port = 25570;
        }
        {
            from = "host";
            host.port = 25571;
            guest.port = 25571;
        }
        {
            from = "host";
            host.port = 25572;
            guest.port = 25572;
        }
    ];
}
