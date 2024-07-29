{config, pkgs, lib, ...}: with lib.types; let
    tools = import ../tools.nix { inherit pkgs lib; };
in with tools; {
    _version = intopt 29;
    block-updates = {
        disable-chorus-plant-updates = fbool;
        disable-mushroom-block-updates = fbool;
        disable-noteblock-updates = fbool;
        disable-tripwire-updates = fbool;
    };
    chunk-loading-advanced = {
        auto-config-send-distance = tbool;
        player-max-concurrent-chunk-generates = intopt 0;
        player-max-concurrent-chunk-loads = intopt 0;
    };
    chunk-loading-basic = {
        player-max-chunk-generate-rate = fopt (-1.0);
        player-max-chunk-load-rate = fopt 100.0;
        player-max-chunk-send-rate = fopt 75.0;
    };
    chunk-system = {
        gen-parallelism = stropt "default";
        io-threads = intopt (-1);
        worker-threads = intopt (-1);
    };
    collisions = {
        enable-player-collisions = tbool;
        send-full-pos-for-hard-colliding-entities = tbool;
    };
    commands = {
        fix-target-selector-tag-completion = tbool;
        suggest-player-names-when-null-tab-completions = tbool;
        time-command-affects-all-worlds = fbool;
    };
    console = {
        enable-brigadier-completions = tbool;
        enable-brigadier-highlighting = tbool;
        has-all-permissions = fbool;
    };
    item-validation = {
        book = {
            author = intopt 8192;
            page = intopt 16384;
            title = intopt 8192;
        };
        book-size = {
            page-max = intopt 2560;
            total-multiplier = fopt 0.98;
        };
        display-name = intopt 8192;
        lore-line = intopt 8192;
        resolve-selectors-in-books = fbool;
    };
    logging = {
      deobfuscate-stacktraces = tbool;
    };
    messages = {
        kick = {
            authentication-servers-down = stropt "<lang:multiplayer.disconnect.authservers_down>";
            connection-throttle = stropt "Connection throttled! Please wait before reconnecting.";
            flying-player = stropt "<lang:multiplayer.disconnect.flying>";
            flying-vehicle = stropt "<lang:multiplayer.disconnect.flying>";
        };
        no-permission = stropt "<red>I'm sorry, but you do not have permission to perform this command.
            Please contact the server administrators if you believe that this is in error.";
        use-display-name-in-quit-message = fbool;
    };
    misc = {
        chat-threads = {
            chat-executor-core-size = intopt (-1);
            chat-executor-max-size = intopt (-1);
        };
        compression-level = stropt "default";
        fix-entity-position-desync = tbool;
        load-permissions-yml-before-plugins = tbool;
        max-joins-per-tick = intopt 5;
        region-file-cache-size = intopt 256;
        strict-advancement-dimension-check = fbool;
        use-alternative-luck-formula = fbool;
        use-dimension-type-for-custom-spawners = fbool;
    };
    packet-limiter = {
        all-packets = {
            action = stropt "KICK";
            interval = fopt 7.0;
            max-packet-rate = fopt 500.0;
        };
        kick-message = stropt "<red><lang:disconnect.exceeded_packet_rate>";
        overrides = {
            ServerboundPlaceRecipePacket = {
                action = stropt "DROP";
                interval = fopt 4.0;
                max-packet-rate = fopt 5.0;
            };
        };
    };
    player-auto-save = {
        max-per-tick = intopt (-1);
        rate = intopt (-1);
    };
    proxies = {
        bungee-cord = {
            online-mode = tbool;
        };
        proxy-protocol = fbool;
        velocity = {
            enabled = tbool;
            online-mode = tbool;
            secret = stropt config.skademaskinen.minecraft.secret;
        };
    };
    scoreboards = {
        save-empty-scoreboard-teams = tbool;
        track-plugin-scoreboards = fbool;
    };
    spam-limiter = {
        incoming-packet-threshold = intopt 300;
        recipe-spam-increment = intopt 1;
        recipe-spam-limit = intopt 20;
        tab-spam-increment = intopt 1;
        tab-spam-limit = intopt 500;
    };
    spark = {
        enable-immediately = fbool;
        enabled = tbool;
    };
    timings = {
        enabled = fbool;
        hidden-config-entries = slist ["database" "proxies.velocity.secret"];
        history-interval = intopt 300;
        history-length = intopt 3600;
        server-name = stropt "Unknown Server";
        server-name-privacy = fbool;
        url = stropt "https://timings.aikar.co/";
        verbose = tbool;
    };
    unsupported-settings = {
        allow-headless-pistons = fbool;
        allow-permanent-block-break-exploits = fbool;
        allow-piston-duplication = fbool;
        allow-tripwire-disarming-exploits = fbool;
        allow-unsafe-end-portal-teleportation = fbool;
        compression-format = stropt "ZLIB";
        perform-username-validation = tbool;
        skip-vanilla-damage-tick-when-shield-blocked = fbool;
    };
    watchdog = {
        early-warning-delay = intopt 10000;
        early-warning-every = intopt 5000;
    };
}