{config, pkgs, ...}: let
    cfg = config.skademaskinen.minecraft;
    prefix = "${config.skademaskinen.storage}/minecraft";
    tools = import ./options/tools.nix { lib = pkgs.lib; };

    paper = pkgs.fetchurl {
        url = "https://api.papermc.io/v2/projects/paper/versions/1.21/builds/109/downloads/paper-1.21-109.jar";
        sha256 = "sha256-dsYGExSUEl8GTcLtQBuUbUoS4IvwzNvzLtqgi2Yzwwo=";
    };
    
    paper-wrapped = server: pkgs.stdenv.mkDerivation {
        name = "paper-wrapped-${server.name}";
        src = ./.;
        installPhase = let
            pg = server.paper-global;
            s = server.spigot;
            b = server.bukkit;
        in with tools; ''
            mkdir -p $out/{bin,share}
            cat > $out/share/eula.txt << EOF
                eula=true
            EOF

            cat > $out/share/server.properties << EOF
                accepts-transfers=${parseValue server.accepts-transfers}
                allow-flight=${parseValue server.allow-flight}
                allow-nether=${parseValue server.allow-nether}
                broadcast-console-to-ops=${parseValue server.broadcast-console-to-ops}
                broadcast-rcon-to-ops=${parseValue server.broadcast-rcon-to-ops}
                debug=${parseValue server.debug}
                difficulty=${server.difficulty}
                enable-command-block=${parseValue server.enable-command-block}
                enable-jmx-monitoring=${parseValue server.enable-jmx-monitoring}
                enable-query=${parseValue server.enable-query}
                enable-rcon=${parseValue server.enable-rcon}
                enable-status=${parseValue server.enable-status}
                enforce-secure-profile=${parseValue server.enforce-secure-profile}
                enforce-whitelist=${parseValue server.enforce-whitelist}
                entity-broadcast-range-percentage=${parseValue server.entity-broadcast-range-percentage}
                force-gamemode=${parseValue server.force-gamemode}
                function-permission-level=${parseValue server.function-permission-level}
                gamemode=${server.gamemode}
                generate-structures=${parseValue server.generate-structures}
                hardcore=${parseValue server.hardcore}
                hide-online-players=${parseValue server.hide-online-players}
                initial-enabled-packs=${server.initial-enabled-packs}
                level-name=${server.level-name}
                level-seed=${server.level-seed}
                level-type=${server.level-type}
                log-ips=${parseValue server.log-ips}
                max-chained-neighbor-updates=${parseValue server.max-chained-neighbor-updates}
                max-players=${parseValue server.max-players}
                max-tick-time=${parseValue server.max-tick-time}
                max-world-size=${parseValue server.max-world-size}
                motd=${server.motd}
                network-compression-threshold=${parseValue server.network-compression-threshold}
                online-mode=${parseValue server.online-mode}
                op-permission-level=${parseValue server.op-permission-level}
                player-idle-timeout=${parseValue server.player-idle-timeout}
                prevent-proxy-connections=${parseValue server.prevent-proxy-connections}
                pvp=${parseValue server.pvp}
                query.port=${parseValue server.query.port}
                rate-limit=${parseValue server.rate-limit}
                rcon.password=${server.rcon.password}
                rcon.port=${parseValue server.rcon.port}
                region-file-compression=${server.region-file-compression}
                require-resource-pack=${parseValue server.require-resource-pack}
                server-ip=${server.server-ip}
                server-port=${parseValue server.server-port}
                simulation-distance=${parseValue server.simulation-distance}
                spawn-animals=${parseValue server.spawn-animals}
                spawn-monsters=${parseValue server.spawn-monsters}
                spawn-npcs=${parseValue server.spawn-npcs}
                spawn-protection=${parseValue server.spawn-protection}
                sync-chunk-writes=${parseValue server.sync-chunk-writes}
                use-native-transport=${parseValue server.use-native-transport}
                view-distance=${parseValue server.view-distance}
                white-list=${parseValue server.white-list}
            EOF

            cat > $out/share/paper-global.yml << EOF
                _version: ${parseValue pg._version}
                block-updates:
                    disable-chorus-plant-updates: ${parseValue pg.block-updates.disable-chorus-plant-updates}
                    disable-mushroom-block-updates: ${parseValue pg.block-updates.disable-mushroom-block-updates}
                    disable-noteblock-updates: ${parseValue pg.block-updates.disable-noteblock-updates}
                    disable-tripwire-updates: ${parseValue pg.block-updates.disable-tripwire-updates}
                chunk-loading-advanced:
                    auto-config-send-distance: ${parseValue pg.chunk-loading-advanced.auto-config-send-distance}
                    player-max-concurrent-chunk-generates: ${parseValue pg.chunk-loading-advanced.player-max-concurrent-chunk-generates}
                    player-max-concurrent-chunk-loads: ${parseValue pg.chunk-loading-advanced.player-max-concurrent-chunk-loads}
                chunk-loading-basic:
                    player-max-chunk-generate-rate: ${parseValue pg.chunk-loading-basic.player-max-chunk-generate-rate}
                    player-max-chunk-load-rate: ${parseValue pg.chunk-loading-basic.player-max-chunk-load-rate}
                    player-max-chunk-send-rate: ${parseValue pg.chunk-loading-basic.player-max-chunk-send-rate}
                chunk-system:
                    gen-parallelism: ${pg.chunk-system.gen-parallelism}
                    io-threads: ${parseValue pg.chunk-system.io-threads}
                    worker-threads: ${parseValue pg.chunk-system.worker-threads}
                collisions:
                    enable-player-collisions: ${parseValue pg.collisions.enable-player-collisions}
                    send-full-pos-for-hard-colliding-entities: ${parseValue pg.collisions.send-full-pos-for-hard-colliding-entities}
                commands:
                    fix-target-selector-tag-completion: ${parseValue pg.commands.fix-target-selector-tag-completion}
                    suggest-player-names-when-null-tab-completions: ${parseValue pg.commands.suggest-player-names-when-null-tab-completions}
                    time-command-affects-all-worlds: ${parseValue pg.commands.time-command-affects-all-worlds}
                console:
                    enable-brigadier-completions: ${parseValue pg.console.enable-brigadier-completions}
                    enable-brigadier-highlighting: ${parseValue pg.console.enable-brigadier-highlighting}
                    has-all-permissions: ${parseValue pg.console.has-all-permissions}
                item-validation:
                    book:
                        author: ${parseValue pg.item-validation.book.author}
                        page: ${parseValue pg.item-validation.book.page}
                        title: ${parseValue pg.item-validation.book.title}
                    book-size:
                        page-max: ${parseValue pg.item-validation.book-size.page-max}
                        total-multiplier: ${parseValue pg.item-validation.book-size.total-multiplier}
                    display-name: ${parseValue pg.item-validation.display-name}
                    lore-line: ${parseValue pg.item-validation.lore-line}
                    resolve-selectors-in-books: ${parseValue pg.item-validation.resolve-selectors-in-books}
                logging:
                    deobfuscate-stacktraces: ${parseValue pg.logging.deobfuscate-stacktraces}
                messages:
                    kick:
                        authentication-servers-down: ${pg.messages.kick.authentication-servers-down}
                        connection-throttle: ${pg.messages.kick.connection-throttle}
                        flying-player: ${pg.messages.kick.flying-player}
                        flying-vehicle: ${pg.messages.kick.flying-vehicle}
                    no-permission: ${pg.messages.no-permission}
                    use-display-name-in-quit-message: ${parseValue pg.messages.use-display-name-in-quit-message}
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

            cat > $out/share/paper-world-defaults.yml << EOF
            EOF

            cat > $out/bin/paper-wrapped << EOF
                mkdir -p ${prefix}/${server.name}/config
                cd ${prefix}/${server.name}
                ln -s $out/share/eula.txt ${prefix}/${server.name}/eula.txt
                cp $out/share/paper-global.yml ${prefix}/${server.name}/config
                cp $out/share/paper-world-defaults.yml ${prefix}/${server.name}/config
                cp $out/share/server.properties ${prefix}/${server.name}
                cp $out/share/bukkit.yml ${prefix}/${server.name}
                cp $out/share/spigot.yml ${prefix}/${server.name}

                ${pkgs.jdk21}/bin/java -jar ${paper}
            EOF
            chmod +x $out/bin/paper-wrapped
        '';
    };
in paper-wrapped
