{lib, ...}: with lib.types; let
    tools = import ../tools.nix { lib = lib; };
in with tools; {
    _version = intopt 31;
    anticheat = {
      anti-xray = {
        enabled = fbool;
        engine-mode = intopt 1;
        hidden-blocks = lib.mkOption {
          type = listOf str;
          default = [
            "copper_ore"
            "deepslate_copper_ore"
            "raw_copper_block"
            "gold_ore"
            "deepslate_gold_ore"
            "iron_ore"
            "deepslate_iron_ore"
            "raw_iron_block"
            "coal_ore"
            "deepslate_coal_ore"
            "lapis_ore"
            "deepslate_lapis_ore"
            "mossy_cobblestone"
            "obsidian"
            "chest"
            "diamond_ore"
            "deepslate_diamond_ore"
            "redstone_ore"
            "deepslate_redstone_ore"
            "clay"
            "emerald_ore"
            "deepslate_emerald_ore"
            "ender_chest"
          ];
        };
        lava-obscures = fbool;
        max-block-height = intopt 64;
        replacement-blocks = lib.mkOption {
          type = listOf str;
          default = [
            "stone"
            "oak_planks"
            "deepslate"
          ];
        };
        update-radius = intopt 2;
        use-permission = fbool;
      };
      obfuscation = {
        items = {
          hide-durability = fbool;
          hide-itemmeta = fbool;
          hide-itemmeta-with-visual-effects = fbool;
        };
      };
    };
    chunks = {
      auto-save-interval = stropt "default";
      delay-chunk-unloads-by = stropt "10s";
      entity-per-chunk-save-limit = {
        arrow = intopt (-1);
        ender_pearl = intopt (-1);
        experience_orb = intopt (-1);
        fireball = intopt (-1);
        small_fireball = intopt (-1);
        snowball = intopt (-1);
      };
      fixed-chunk-inhabited-time = intopt (-1);
      flush-regions-on-save = fbool;
      max-auto-save-chunks-per-tick = intopt 24;
      prevent-moving-into-unloaded-chunks = fbool;
    };
    collisions = {
      allow-player-cramming-damage = fbool;
      allow-vehicle-collisions = tbool;
      fix-climbing-bypassing-cramming-rule = fbool;
      max-entity-collisions = intopt 8;
      only-players-collide = fbool;
    };
    command-blocks = {
      force-follow-perm-level = tbool;
      permissions-level = intopt 2;
    };
    entities = {
      armor-stands = {
        do-collision-entity-lookups = tbool;
        tick = tbool;
      };
      behavior = {
        allow-spider-world-border-climbing = tbool;
        baby-zombie-movement-modifier = fopt 0.5;
        disable-chest-cat-detection = fbool;
        disable-creeper-lingering-effect = fbool;
        disable-player-crits = fbool;
        door-breaking-difficulty = {
          husk = slist ["HARD"];
          vindicator = slist ["NORMAL" "HARD"];
          zombie = slist ["HARD"];
          zombie_villager = slist ["HARD"];
          zombified_piglin = slist ["HARD"];
        };
        ender-dragons-death-always-places-dragon-egg = fbool;
        experience-merge-max-value = intopt (-1);
        mobs-can-always-pick-up-loot = {
          skeletons = fbool;
          zombies = fbool;
        };
        nerf-pigmen-from-nether-portals = fbool;
        parrots-are-unaffected-by-player-movement = fbool;
        phantoms-do-not-spawn-on-creative-players = tbool;
        phantoms-only-attack-insomniacs = tbool;
        phantoms-spawn-attempt-max-seconds = intopt 119;
        phantoms-spawn-attempt-min-seconds = intopt 60;
        piglins-guard-chests = tbool;
        pillager-patrols = {
          disable = fbool;
          spawn-chance = fopt 0.2;
          spawn-delay = {
            per-player = fbool;
            ticks = intopt 12000;
          };
          start = {
            day = intopt 5;
            per-player = fbool;
          };
        };
        player-insomnia-start-ticks = intopt 72000;
        should-remove-dragon = fbool;
        spawner-nerfed-mobs-should-jump = fbool;
        zombie-villager-infection-chance = stropt "default";
        zombies-target-turtle-eggs = tbool;
      };
      entities-target-with-follow-range = fbool;
      markers = {
        tick = tbool;
      };
      mob-effects = {
        immune-to-wither-effect = {
          wither = tbool;
          wither-skeleton = tbool;
        };
        spiders-immune-to-poison-effect = tbool;
      };
      sniffer = {
        boosted-hatch-time = stropt "default";
        hatch-time = stropt "default";
      };
      spawning = {
        all-chunks-are-slime-chunks = fbool;
        alt-item-despawn-rate = {
          enabled = fbool;
          items = {
            cobblestone = intopt 300;
          };
        };
        count-all-mobs-for-spawning = fbool;
        creative-arrow-despawn-rate = stropt "default";
        despawn-ranges = {
          ambient = {
            hard = intopt 128;
            soft = intopt 32;
          };
          axolotls = {
            hard = intopt 128;
            soft = intopt 32;
          };
          creature = {
            hard = intopt 128;
            soft = intopt 32;
          };
          misc = {
            hard = intopt 128;
            soft = intopt 32;
          };
          monster = {
            hard = intopt 128;
            soft = intopt 32;
          };
          underground_water_creature = {
            hard = intopt 128;
            soft = intopt 32;
          };
          water_ambient = {
            hard = intopt 64;
            soft = intopt 32;
          };
          water_creature = {
            hard = intopt 128;
            soft = intopt 32;
          };
        };
        disable-mob-spawner-spawn-egg-transformation = fbool;
        duplicate-uuid = {
          mode = stropt "SAFE_REGEN";
          safe-regen-delete-range = intopt 32;
        };
        filter-bad-tile-entity-nbt-from-falling-blocks = tbool;
        filtered-entity-tag-nbt-paths = slist [
          "Pos"
          "Motion"
          "SleepingX"
          "SleepingY"
          "SleepingZ"
        ];
        iron-golems-can-spawn-in-air = fbool;
        monster-spawn-max-light-level = stropt "default";
        non-player-arrow-despawn-rate = stropt "default";
        per-player-mob-spawns = tbool;
        scan-for-legacy-ender-dragon = tbool;
        skeleton-horse-thunder-spawn-chance = stropt "default";
        slime-spawn-height = {
          slime-chunk = {
            maximum = fopt 40.0;
          };
          surface-biome = {
            maximum = fopt 70.0;
            minimum = fopt 50.0;
          };
        };
        spawn-limits = {
          ambient = intopt (-1);
          axolotls = intopt (-1);
          creature = intopt (-1);
          monster = intopt (-1);
          underground_water_creature = intopt (-1);
          water_ambient = intopt (-1);
          water_creature = intopt (-1);
        };
        ticks-per-spawn = {
          ambient = intopt (-1);
          axolotls = intopt (-1);
          creature = intopt (-1);
          monster = intopt (-1);
          underground_water_creature = intopt (-1);
          water_ambient = intopt (-1);
          water_creature = intopt (-1);
        };
        wandering-trader = {
          spawn-chance-failure-increment = intopt 25;
          spawn-chance-max = intopt 75;
          spawn-chance-min = intopt 25;
          spawn-day-length = intopt 24000;
          spawn-minute-length = intopt 1200;
        };
        wateranimal-spawn-height = {
          maximum = stropt "default";
          minimum = stropt "default";
        };
      };
      tracking-range-y = {
        animal = stropt "default";
        display = stropt "default";
        enabled = fbool;
        misc = stropt "default";
        monster = stropt "default";
        other = stropt "default";
        player = stropt "default";
      };
    };
    environment = {
      disable-explosion-knockback = fbool;
      disable-ice-and-snow = fbool;
      disable-teleportation-suffocation-check = fbool;
      disable-thunder = fbool;
      fire-tick-delay = intopt 30;
      frosted-ice = {
        delay = {
          max = intopt 40;
          min = intopt 20;
        };
        enabled = tbool;
      };
      generate-flat-bedrock = fbool;
      locate-structures-outside-world-border = fbool;
      max-block-ticks = intopt 65536;
      max-fluid-ticks = intopt 65536;
      nether-ceiling-void-damage-height = stropt "disabled";
      optimize-explosions = fbool;
      portal-create-radius = intopt 16;
      portal-search-radius = intopt 128;
      portal-search-vanilla-dimension-scaling = tbool;
      treasure-maps = {
        enabled = tbool;
        find-already-discovered = {
          loot-tables = stropt "default";
          villager-trade = fbool;
        };
      };
      water-over-lava-flow-speed = intopt 5;
    };
    feature-seeds = {
      generate-random-seeds-for-all = fbool;
    };
    fishing-time-range = {
      maximum = intopt 600;
      minimum = intopt 100;
    };
    fixes = {
      disable-unloaded-chunk-enderpearl-exploit = tbool;
      falling-block-height-nerf = stropt "disabled";
      fix-items-merging-through-walls = fbool;
      prevent-tnt-from-moving-in-water = fbool;
      split-overstacked-loot = tbool;
      tnt-entity-height-nerf = stropt "disabled";
    };
    hopper = {
      cooldown-when-full = tbool;
      disable-move-event = fbool;
      ignore-occluding-blocks = fbool;
    };
    lootables = {
      auto-replenish = fbool;
      max-refills = intopt (-1);
      refresh-max = stropt "2d";
      refresh-min = stropt "12h";
      reset-seed-on-fill = tbool;
      restrict-player-reloot = tbool;
      restrict-player-reloot-time = stropt "disabled";
    };
    maps = {
      item-frame-cursor-limit = intopt 128;
      item-frame-cursor-update-interval = intopt 10;
    };
    max-growth-height = {
      bamboo = {
        max = intopt 16;
        min = intopt 11;
      };
      cactus = intopt 3;
      reeds = intopt 3;
    };
    misc = {
      disable-end-credits = fbool;
      disable-relative-projectile-velocity = fbool;
      disable-sprint-interruption-on-attack = fbool;
      light-queue-size = intopt 20;
      max-leash-distance = fopt 10.0;
      redstone-implementation = stropt "VANILLA";
      shield-blocking-delay = intopt 5;
      show-sign-click-command-failure-msgs-to-player = fbool;
      update-pathfinding-on-block-update = tbool;
    };
    scoreboards = {
      allow-non-player-entities-on-scoreboards = tbool;
      use-vanilla-world-scoreboard-name-coloring = fbool;
    };
    spawn = {
      allow-using-signs-inside-spawn-protection = fbool;
    };
    tick-rates = {
      behavior = {
        villager = {
          validatenearbypoi = intopt (-1);
        };
      };
      container-update = intopt 1;
      dry-farmland = intopt 1;
      grass-spread = intopt 1;
      mob-spawner = intopt 1;
      sensor = {
        villager = {
          secondarypoisensor = intopt 40;
        };
      };
      wet-farmland = intopt 1;
    };
    unsupported-settings = {
      disable-world-ticking-when-empty = fbool;
      fix-invulnerable-end-crystal-exploit = tbool;
    };
}