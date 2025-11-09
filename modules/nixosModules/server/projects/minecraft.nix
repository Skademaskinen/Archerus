{ pkgs, lib, system, nix-minecraft, ... }:

let
    servers = nix-minecraft.legacyPackages.${system};
    secret = "velocity-secret";
    mkProxy = lib.mkProxy;
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
        DBurley93 = "fad4dfbc-c577-4d7e-ac1d-cf7f74229c07";
        Jinxy_93 = "6983cea2-891d-487b-9334-74cf827baf9e";
        herpinmaderp = "9c0c8e6c-ee7b-429b-a690-83f93495fe44";
        Wesant = "712af801-9089-4a52-b8bb-3dfff399bdc3";
        EpiLunaria = "51f39653-bdfb-4149-8841-3caef174aeb7";
        GO_AWAY_77 = "eb8b3aa6-3a1f-4dda-b2f1-a0e05e939f7f";
    };
    ops = [
        {
            uuid = "cb7971ff-7089-429b-ad5f-609ffbcd2ddb";
            name = "mast3r_waf1z";
            level = 4;
            bypassesPlayerLimit = true;
        }
        {
            uuid = "010e5ef3-a1fb-4c2e-819c-35c96285fc1e";
            name = "Power_Supply";
            level = 4;
            bypassesPlayerLimit = true;
        }
    ];
in

{ config, ... }:

let
    secure = config.skade.baseDomain != "localhost";
in

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
                        motd = "< <#ff5500>${config.networking.hostName} <reset>>                      <u>https://${config.skade.baseDomain}</u>
                        Minecraft on NixOS";
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
                    force-gamemode = true;
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
                    level-type = "FLAT";
                    generator-settings = builtins.toJSON {
                        layers = [
                            {
                                block = "air";
                                height = "1";
                            }
                        ];
                        biome = "the_void";
                    };
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
                    "plugins/iportal.jar" = pkgs.fetchurl {
                        url = "https://github.com/JuL1En1997/Iportal/releases/download/major-update/Iportal-Updated-2.0.jar";
                        sha256 = "sha256-uF4Izym8nvQVo8jhm41AG5re4RrUYUmVjFPsHIuBiyI=";
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
                    allow-nether = true;
                    difficulty = "hard";
                    pvp = true;
                    spawn-animals = true;
                    spawn-monsters = true;
                    spawn-npcs = true;
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

                jvmOpts = "-Xmx4G -Xms2G";

                serverProperties = {
                    server-port = 25572;
                    online-mode = false;
                    gamemode = "survival";
                    allow-nether = true;
                    difficulty = "hard";
                    pvp = true;
                    spawn-animals = true;
                    spawn-monsters = true;
                    spawn-npcs = true;
                    #spawn-protection = 256;
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
                    #"mods/immersive-portals.jar" = pkgs.fetchurl {
                    #    url = "https://cdn.modrinth.com/data/zJpHMkdD/versions/155jtqJi/immersive-portals-3.3.9-mc1.20.1-fabric.jar";
                    #    sha256 = "sha256-vrNfdLmLU3t7V3Q7aFT88ZAAqabZP2EfZJQBOD5mAE4=";
                    #};
                    "mods/cross-stitch.jar" = pkgs.fetchurl {
                        url = "https://cdn.modrinth.com/data/YkOyn1Pn/versions/dJioNlO8/crossstitch-0.1.6.jar";
                        sha256 = "sha256-z1qsXFV5sc6xsr0loV8eLcySJvV2cBY60fhBsvkFuC4=";
                    };
                    "mods/dynmap.jar" = pkgs.fetchurl {
                        url = "https://cdn.modrinth.com/data/fRQREgAc/versions/IIQSYMHC/Dynmap-3.7-beta-6-fabric-1.20.jar";
                        sha256 = "sha256-iDtnQSFzRkvaaNGr6Bjm4EbdJQZB0u75JpiPTsrF+is=";
                    };
                    "mods/jei.jar" = pkgs.fetchurl {
                        url = "https://cdn.modrinth.com/data/u6dRKJwZ/versions/ziulPKuI/jei-1.20.1-fabric-15.20.0.116.jar";
                        sha256 = "sha256-/B6JyHTjHm8MO5qaHacOpJw9ae4oQDsrgIBRpfGMgac=";
                    };
                    "mods/create-jetpack.jar" = pkgs.fetchurl {
                        url = "https://cdn.modrinth.com/data/UbFnAd4l/versions/lKhjIqZR/create_jetpack-fabric-4.3.0.jar";
                        sha256 = "sha256-66D9qYHdml4aO8rvoqkimqBMXgY7WHZ3sGYc+RAbp1g=";
                    };
                    "mods/create-power-loader.jar" = pkgs.fetchurl {
                        url = "https://cdn.modrinth.com/data/E9MuZ1zB/versions/fHsTW7eS/create_power_loader-1.5.3-mc1.20.1-fabric.jar";
                        sha256 = "sha256-7x3tucq1bVcuYqzYLb4z7LuuRrYaP3hQi4FGndfFZDg=";
                    };
                    "mods/fabric-language-kotlin.jar" = pkgs.fetchurl {
                        url = "https://cdn.modrinth.com/data/Ha28R6CL/versions/a7MqDLdC/fabric-language-kotlin-1.10.20%2Bkotlin.1.9.24.jar";
                        sha256 = "sha256-ugllaqwKcuGo/caG7M2UVBVXwxTkib0s+7qntzUUkzc=";
                    };
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
    services.nginx.virtualHosts."modded.${config.skade.baseDomain}" = mkProxy config {
        inherit secure;
        path = "/";
        location = "http://localhost:8123";
    };
    skade.docs.vhosts."modded.${config.skade.baseDomain}".port = 8123;

}
