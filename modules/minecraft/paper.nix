{config, pkgs, ...}: let
    cfg = config.skademaskinen.minecraft;
    prefix = "${config.skademaskinen.storage}/minecraft";

    paper = pkgs.fetchurl {
        url = "https://api.papermc.io/v2/projects/paper/versions/1.21/builds/109/downloads/paper-1.21-109.jar";
        sha256 = "sha256-dsYGExSUEl8GTcLtQBuUbUoS4IvwzNvzLtqgi2Yzwwo=";
    };
    
    getIndex = xs: x: i: if i > (builtins.length xs) then 
        i
    else if builtins.elemAt xs i == x then 
        i
    else 
        getIndex xs x (i+1);

    paper-wrapped = name: pkgs.stdenv.mkDerivation {
        name = "paper-wrapped-${name}";
        src = ./.;
        installPhase = ''
            mkdir -p $out/{bin,share}
            cat > $out/share/eula.txt << EOF
                eula=true
            EOF

            cat > $out/share/server.properties << EOF
                accepts-transfers=false
                allow-flight=false
                allow-nether=true
                broadcast-console-to-ops=true
                broadcast-rcon-to-ops=true
                bug-report-link=
                debug=false
                difficulty=easy
                enable-command-block=false
                enable-jmx-monitoring=false
                enable-query=false
                enable-rcon=false
                enable-status=true
                enforce-secure-profile=false
                enforce-whitelist=false
                entity-broadcast-range-percentage=100
                force-gamemode=false
                function-permission-level=2
                gamemode=survival
                generate-structures=true
                generator-settings={}
                hardcore=false
                hide-online-players=false
                initial-disabled-packs=
                initial-enabled-packs=vanilla
                level-name=world
                level-seed=
                level-type=minecraft\:normal
                log-ips=true
                max-chained-neighbor-updates=1000000
                max-players=20
                max-tick-time=60000
                max-world-size=29999984
                motd=A Minecraft Server
                network-compression-threshold=256
                online-mode=false
                op-permission-level=4
                player-idle-timeout=0
                prevent-proxy-connections=false
                pvp=true
                query.port=25566
                rate-limit=0
                rcon.password=
                rcon.port=25575
                region-file-compression=deflate
                require-resource-pack=false
                resource-pack=
                resource-pack-id=
                resource-pack-prompt=
                resource-pack-sha1=
                server-ip=
                server-port=${builtins.toString (cfg.port-range-start + (getIndex cfg.servers name 0) + 1)}
                simulation-distance=10
                spawn-animals=true
                spawn-monsters=true
                spawn-npcs=true
                spawn-protection=16
                sync-chunk-writes=true
                text-filtering-config=
                use-native-transport=true
                view-distance=10
                white-list=false
            EOF

            cat > $out/share/paper-global.yml << EOF
                _version: 29
                block-updates:
                    disable-chorus-plant-updates: false
                    disable-mushroom-block-updates: false
                    disable-noteblock-updates: false
                    disable-tripwire-updates: false
                chunk-loading-advanced:
                    auto-config-send-distance: true
                    player-max-concurrent-chunk-generates: 0
                    player-max-concurrent-chunk-loads: 0
                chunk-loading-basic:
                    player-max-chunk-generate-rate: -1.0
                    player-max-chunk-load-rate: 100.0
                    player-max-chunk-send-rate: 75.0
                chunk-system:
                    gen-parallelism: default
                    io-threads: -1
                    worker-threads: -1
                collisions:
                    enable-player-collisions: true
                    send-full-pos-for-hard-colliding-entities: true
                commands:
                    fix-target-selector-tag-completion: true
                    suggest-player-names-when-null-tab-completions: true
                    time-command-affects-all-worlds: false
                console:
                    enable-brigadier-completions: true
                    enable-brigadier-highlighting: true
                    has-all-permissions: false
                item-validation:
                    book:
                        author: 8192
                        page: 16384
                        title: 8192
                    book-size:
                        page-max: 2560
                        total-multiplier: 0.98
                    display-name: 8192
                    lore-line: 8192
                    resolve-selectors-in-books: false
                logging:
                    deobfuscate-stacktraces: true
                messages:
                    kick:
                        authentication-servers-down: <lang:multiplayer.disconnect.authservers_down>
                        connection-throttle: Connection throttled! Please wait before reconnecting.
                        flying-player: <lang:multiplayer.disconnect.flying>
                        flying-vehicle: <lang:multiplayer.disconnect.flying>
                    no-permission: <red>I'm sorry, but you do not have permission to perform this command.
                        Please contact the server administrators if you believe that this is in error.
                    use-display-name-in-quit-message: false
                misc:
                    chat-threads:
                        chat-executor-core-size: -1
                        chat-executor-max-size: -1
                    compression-level: default
                    fix-entity-position-desync: true
                    load-permissions-yml-before-plugins: true
                    max-joins-per-tick: 5
                    region-file-cache-size: 256
                    strict-advancement-dimension-check: false
                    use-alternative-luck-formula: false
                    use-dimension-type-for-custom-spawners: false
                packet-limiter:
                    all-packets:
                        action: KICK
                        interval: 7.0
                        max-packet-rate: 500.0
                    kick-message: <red><lang:disconnect.exceeded_packet_rate>
                    overrides:
                        ServerboundPlaceRecipePacket:
                            action: DROP
                            interval: 4.0
                            max-packet-rate: 5.0
                player-auto-save:
                    max-per-tick: -1
                    rate: -1
                proxies:
                    bungee-cord:
                        online-mode: true
                    proxy-protocol: false
                    velocity:
                        enabled: true
                        online-mode: true
                        secret: ${cfg.secret}
                scoreboards:
                    save-empty-scoreboard-teams: true
                    track-plugin-scoreboards: false
                spam-limiter:
                    incoming-packet-threshold: 300
                    recipe-spam-increment: 1
                    recipe-spam-limit: 20
                    tab-spam-increment: 1
                    tab-spam-limit: 500
                spark:
                    enable-immediately: false
                    enabled: true
                timings:
                    enabled: false
                    hidden-config-entries:
                    - database
                    - proxies.velocity.secret
                    history-interval: 300
                    history-length: 3600
                    server-name: Unknown Server
                    server-name-privacy: false
                    url: https://timings.aikar.co/
                    verbose: true
                unsupported-settings:
                    allow-headless-pistons: false
                    allow-permanent-block-break-exploits: false
                    allow-piston-duplication: false
                    allow-tripwire-disarming-exploits: false
                    allow-unsafe-end-portal-teleportation: false
                    compression-format: ZLIB
                    perform-username-validation: true
                    skip-vanilla-damage-tick-when-shield-blocked: false
                watchdog:
                    early-warning-delay: 10000
                    early-warning-every: 5000
            EOF

            cat > $out/bin/paper-wrapped << EOF
                mkdir -p ${prefix}/${name}/config
                cd ${prefix}/${name}
                ln -s $out/share/eula.txt ${prefix}/${name}/eula.txt
                cp $out/share/paper-global.yml ${prefix}/${name}/config

                ${pkgs.jdk21}/bin/java -jar ${paper} -c $out/share/server.properties
            EOF
            chmod +x $out/bin/paper-wrapped
        '';
    };
in paper-wrapped