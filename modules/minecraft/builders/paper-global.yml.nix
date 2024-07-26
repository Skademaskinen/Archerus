{lib, config, ...}: let
    tools = import ../tools.nix { lib = lib; };
in paper-global-settings: with paper-global-settings; with tools; ''
cat > $out/share/paper-global.yml << EOF
_version: ${parseValue _version}
block-updates:
    disable-chorus-plant-updates: ${parseValue block-updates.disable-chorus-plant-updates}
    disable-mushroom-block-updates: ${parseValue block-updates.disable-mushroom-block-updates}
    disable-noteblock-updates: ${parseValue block-updates.disable-noteblock-updates}
    disable-tripwire-updates: ${parseValue block-updates.disable-tripwire-updates}
chunk-loading-advanced:
    auto-config-send-distance: ${parseValue chunk-loading-advanced.auto-config-send-distance}
    player-max-concurrent-chunk-generates: ${parseValue chunk-loading-advanced.player-max-concurrent-chunk-generates}
    player-max-concurrent-chunk-loads: ${parseValue chunk-loading-advanced.player-max-concurrent-chunk-loads}
chunk-loading-basic:
    player-max-chunk-generate-rate: ${parseValue chunk-loading-basic.player-max-chunk-generate-rate}
    player-max-chunk-load-rate: ${parseValue chunk-loading-basic.player-max-chunk-load-rate}
    player-max-chunk-send-rate: ${parseValue chunk-loading-basic.player-max-chunk-send-rate}
chunk-system:
    gen-parallelism: ${chunk-system.gen-parallelism}
    io-threads: ${parseValue chunk-system.io-threads}
    worker-threads: ${parseValue chunk-system.worker-threads}
collisions:
    enable-player-collisions: ${parseValue collisions.enable-player-collisions}
    send-full-pos-for-hard-colliding-entities: ${parseValue collisions.send-full-pos-for-hard-colliding-entities}
commands:
    fix-target-selector-tag-completion: ${parseValue commands.fix-target-selector-tag-completion}
    suggest-player-names-when-null-tab-completions: ${parseValue commands.suggest-player-names-when-null-tab-completions}
    time-command-affects-all-worlds: ${parseValue commands.time-command-affects-all-worlds}
console:
    enable-brigadier-completions: ${parseValue console.enable-brigadier-completions}
    enable-brigadier-highlighting: ${parseValue console.enable-brigadier-highlighting}
    has-all-permissions: ${parseValue console.has-all-permissions}
item-validation:
    book:
        author: ${parseValue item-validation.book.author}
        page: ${parseValue item-validation.book.page}
        title: ${parseValue item-validation.book.title}
    book-size:
        page-max: ${parseValue item-validation.book-size.page-max}
        total-multiplier: ${parseValue item-validation.book-size.total-multiplier}
    display-name: ${parseValue item-validation.display-name}
    lore-line: ${parseValue item-validation.lore-line}
    resolve-selectors-in-books: ${parseValue item-validation.resolve-selectors-in-books}
logging:
    deobfuscate-stacktraces: ${parseValue logging.deobfuscate-stacktraces}
messages:
    kick:
        authentication-servers-down: ${messages.kick.authentication-servers-down}
        connection-throttle: ${messages.kick.connection-throttle}
        flying-player: ${messages.kick.flying-player}
        flying-vehicle: ${messages.kick.flying-vehicle}
    no-permission: ${messages.no-permission}
    use-display-name-in-quit-message: ${parseValue messages.use-display-name-in-quit-message}
misc:
    chat-threads:
        chat-executor-core-size: ${parseValue misc.chat-threads.chat-executor-core-size}
        chat-executor-max-size: ${parseValue misc.chat-threads.chat-executor-max-size}
    compression-level: ${parseValue misc.compression-level}
    fix-entity-position-desync: ${parseValue misc.fix-entity-position-desync}
    load-permissions-yml-before-plugins: ${parseValue misc.load-permissions-yml-before-plugins}
    max-joins-per-tick: ${parseValue misc.max-joins-per-tick}
    region-file-cache-size: ${parseValue misc.region-file-cache-size}
    strict-advancement-dimension-check: ${parseValue misc.strict-advancement-dimension-check}
    use-alternative-luck-formula: ${parseValue misc.use-alternative-luck-formula}
    use-dimension-type-for-custom-spawners: ${parseValue misc.use-dimension-type-for-custom-spawners}
packet-limiter:
    all-packets:
        action: ${packet-limiter.all-packets.action}
        interval: ${parseValue packet-limiter.all-packets.interval}
        max-packet-rate: ${parseValue packet-limiter.all-packets.max-packet-rate}
    kick-message: ${packet-limiter.kick-message}
    overrides:
        ServerboundPlaceRecipePacket:
            action: ${packet-limiter.overrides.ServerboundPlaceRecipePacket.action}
            interval: ${parseValue packet-limiter.overrides.ServerboundPlaceRecipePacket.interval}
            max-packet-rate: ${parseValue packet-limiter.overrides.ServerboundPlaceRecipePacket.max-packet-rate}
player-auto-save:
    max-per-tick: ${parseValue player-auto-save.max-per-tick}
    rate: ${parseValue player-auto-save.rate}
proxies:
    bungee-cord:
        online-mode: ${parseValue proxies.bungee-cord.online-mode}
    proxy-protocol: ${parseValue proxies.proxy-protocol}
    velocity:
        enabled: ${parseValue proxies.velocity.enabled}
        online-mode: ${parseValue proxies.velocity.online-mode}
        secret: ${config.skademaskinen.minecraft.secret}
scoreboards:
    save-empty-scoreboard-teams: ${parseValue scoreboards.save-empty-scoreboard-teams}
    track-plugin-scoreboards: ${parseValue scoreboards.track-plugin-scoreboards}
spam-limiter:
    incoming-packet-threshold: ${parseValue spam-limiter.incoming-packet-threshold}
    recipe-spam-increment: ${parseValue spam-limiter.recipe-spam-increment}
    recipe-spam-limit: ${parseValue spam-limiter.recipe-spam-limit}
    tab-spam-increment: ${parseValue spam-limiter.tab-spam-increment}
    tab-spam-limit: ${parseValue spam-limiter.tab-spam-limit}
spark:
    enable-immediately: ${parseValue spark.enable-immediately}
    enabled: ${parseValue spark.enabled}
timings:
    enabled: ${parseValue timings.enabled}
    hidden-config-entries: ${builtins.concatStringsSep "" (map (entry: "    - ${entry}\n") timings.hidden-config-entries)}
    history-interval: ${parseValue timings.history-interval}
    history-length: ${parseValue timings.history-length}
    server-name: ${timings.server-name}
    server-name-privacy: ${parseValue timings.server-name-privacy}
    url: ${timings.url}
    verbose: ${parseValue timings.verbose}
unsupported-settings:
    allow-headless-pistons: ${parseValue unsupported-settings.allow-headless-pistons}
    allow-permanent-block-break-exploits: ${parseValue unsupported-settings.allow-permanent-block-break-exploits}
    allow-piston-duplication: ${parseValue unsupported-settings.allow-piston-duplication}
    allow-tripwire-disarming-exploits: ${parseValue unsupported-settings.allow-tripwire-disarming-exploits}
    allow-unsafe-end-portal-teleportation: ${parseValue unsupported-settings.allow-unsafe-end-portal-teleportation}
    compression-format: ${unsupported-settings.compression-format}
    perform-username-validation: ${parseValue unsupported-settings.perform-username-validation}
    skip-vanilla-damage-tick-when-shield-blocked: ${parseValue unsupported-settings.skip-vanilla-damage-tick-when-shield-blocked}
watchdog:
    early-warning-delay: ${parseValue watchdog.early-warning-delay}
    early-warning-every: ${parseValue watchdog.early-warning-every}
EOF
''