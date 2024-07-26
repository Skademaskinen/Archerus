{lib, ...}: with lib.types; let
    tools = import ../tools.nix { lib = lib; };
in with tools; {
    messages = {
        whitelist = stropt "You are not whitelisted on this server!";
        unknown-command = stropt "Unknown command. Type \"/help\" for help.";
        server-full = stropt "The server is full!";
        outdated-client = stropt "Outdated client! Please use {0}";
        outdated-server = stropt "Outdated server! I'm still on {0}";
        restart = stropt "Server is restarting";
    };
    advancements = {
        disable-saving = fbool;
        disabled = slist ["minecraft:story/disabled"];
    };
    settings = {
        bungeecord = fbool;
        save-user-cache-on-stop-only = fbool;
        sample-count = intopt 12;
        player-shuffle = intopt 0;
        user-cache-size = intopt 1000;
        moved-wrongly-threshold = fopt 0.0625;
        moved-too-quickly-multiplier = fopt 10.0;
        timeout-time = intopt 60;
        restart-on-crash = tbool;
        restart-script = stropt "./start.sh";
        netty-threads = intopt 4;
        attribute = {
            maxAbsorption = {
                max = fopt 2048.0;
            };
            maxHealth = {
                max = fopt 2048.0;
            };
            movementSpeed = {
                max = fopt 2048.0;
            };
            attackDamage = {
                max = fopt 2048.0;
            };
        };
          log-villager-deaths = tbool;
          log-named-deaths = tbool;
          debug = fbool;
    };
    commands = {
        tab-complete = intopt 0;
        send-namespaced = tbool;
        log = tbool;
        spam-exclusions = slist ["/skill"];
        silent-commandblock-console = fbool;
        replace-commands = slist ["setblock" "summon" "testforblock" "tellraw"];
    };
    world-settings = {
        default = {
            below-zero-generation-in-existing-chunks = tbool;
            view-distance = stropt "default";
            simulation-distance = stropt "default";
            thunder-chance = intopt 100000;
            merge-radius = {
                item = fopt 0.5;
                exp = fopt (-1.0);
            };
            mob-spawn-range = intopt 8;
            item-despawn-rate = intopt 6000;
            arrow-despawn-rate = intopt 1200;
            trident-despawn-rate = intopt 1200;
            zombie-aggressive-towards-villager = tbool;
            nerf-spawner-mobs = fbool;
            enable-zombie-pigmen-portal-spawns = tbool;
            wither-spawn-sound-radius = intopt 0;
            end-portal-sound-radius = intopt 0;
            hanging-tick-frequency = intopt 100;
            unload-frozen-chunks = fbool;
            growth = {
                cactus-modifier = intopt 100;
                cane-modifier = intopt 100;
                melon-modifier = intopt 100;
                mushroom-modifier = intopt 100;
                pumpkin-modifier = intopt 100;
                sapling-modifier = intopt 100;
                beetroot-modifier = intopt 100;
                carrot-modifier = intopt 100;
                potato-modifier = intopt 100;
                torchflower-modifier = intopt 100;
                wheat-modifier = intopt 100;
                netherwart-modifier = intopt 100;
                vine-modifier = intopt 100;
                cocoa-modifier = intopt 100;
                bamboo-modifier = intopt 100;
                sweetberry-modifier = intopt 100;
                kelp-modifier = intopt 100;
                twistingvines-modifier = intopt 100;
                weepingvines-modifier = intopt 100;
                cavevines-modifier = intopt 100;
                glowberry-modifier = intopt 100;
                pitcherplant-modifier = intopt 100;
            };
            entity-activation-range = {
                animals = intopt 32;
                monsters = intopt 32;
                raiders = intopt 64;
                misc = intopt 16;
                water = intopt 16;
                villagers = intopt 32;
                flying-monsters = intopt 32;
                wake-up-inactive = {
                    animals-max-per-tick = intopt 4;
                    animals-every = intopt 1200;
                    animals-for = intopt 100;
                    monsters-max-per-tick = intopt 8;
                    monsters-every = intopt 400;
                    monsters-for = intopt 100;
                    villagers-max-per-tick = intopt 4;
                    villagers-every = intopt 600;
                    villagers-for = intopt 100;
                    flying-monsters-max-per-tick = intopt 8;
                    flying-monsters-every = intopt 200;
                    flying-monsters-for = intopt 100;
                };
                villagers-work-immunity-after = intopt 100;
                villagers-work-immunity-for = intopt 20;
                villagers-active-for-panic = tbool;
                tick-inactive-villagers = tbool;
                ignore-spectators = fbool;
            };
            entity-tracking-range = {
                players = intopt 128;
                animals = intopt 96;
                monsters = intopt 96;
                misc = intopt 96;
                display = intopt 128;
                other = intopt 64;
            };
            ticks-per = {
                hopper-transfer = intopt 8;
                hopper-check = intopt 1;
            };
            hopper-amount = intopt 1;
            hopper-can-load-chunks = fbool;
            dragon-death-sound-radius = intopt 0;
            seed-village = intopt 10387312;
            seed-desert = intopt 14357617;
            seed-igloo = intopt 14357618;
            seed-jungle = intopt 14357619;
            seed-swamp = intopt 14357620;
            seed-monument = intopt 10387313;
            seed-shipwreck = intopt 165745295;
            seed-ocean = intopt 14357621;
            seed-outpost = intopt 165745296;
            seed-endcity = intopt 10387313;
            seed-slime = intopt 987234911;
            seed-nether = intopt 30084232;
            seed-mansion = intopt 10387319;
            seed-fossil = intopt 14357921;
            seed-portal = intopt 34222645;
            seed-ancientcity = intopt 20083232;
            seed-trailruins = intopt 83469867;
            seed-trialchambers = intopt 94251327;
            seed-buriedtreasure = intopt 10387320;
            seed-mineshaft = stropt "default";
            seed-stronghold = stropt "default";
            hunger = {
                jump-walk-exhaustion = fopt 0.05;
                jump-sprint-exhaustion = fopt 0.2;
                combat-exhaustion = fopt 0.1;
                regen-exhaustion = fopt 6.0;
                swim-multiplier = fopt 0.01;
                sprint-multiplier = fopt 0.1;
                other-multiplier = fopt 0.0;
            };
            max-tnt-per-tick = intopt 100;
            max-tick-time = {
                tile = intopt 50;
                entity = intopt 50;
            };
            verbose = fbool;
        };
    };
    players = {
        disable-saving = fbool;
    };
    config-version = intopt 12;
    stats = {
        disable-saving = fbool;
        forced-stats = stropt "{}";
    };
}