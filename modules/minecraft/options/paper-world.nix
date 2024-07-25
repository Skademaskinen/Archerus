{lib, ...}: with lib.types; let
    tools = import ./tools.nix { inherit lib; };
in with tools; {
    _version: 31
    anticheat:
      anti-xray:
        enabled: false
        engine-mode: 1
        hidden-blocks:
        - copper_ore
        - deepslate_copper_ore
        - raw_copper_block
        - gold_ore
        - deepslate_gold_ore
        - iron_ore
        - deepslate_iron_ore
        - raw_iron_block
        - coal_ore
        - deepslate_coal_ore
        - lapis_ore
        - deepslate_lapis_ore
        - mossy_cobblestone
        - obsidian
        - chest
        - diamond_ore
        - deepslate_diamond_ore
        - redstone_ore
        - deepslate_redstone_ore
        - clay
        - emerald_ore
        - deepslate_emerald_ore
        - ender_chest
        lava-obscures: false
        max-block-height: 64
        replacement-blocks:
        - stone
        - oak_planks
        - deepslate
        update-radius: 2
        use-permission: false
      obfuscation:
        items:
          hide-durability: false
          hide-itemmeta: false
          hide-itemmeta-with-visual-effects: false
    chunks:
      auto-save-interval: default
      delay-chunk-unloads-by: 10s
      entity-per-chunk-save-limit:
        arrow: -1
        ender_pearl: -1
        experience_orb: -1
        fireball: -1
        small_fireball: -1
        snowball: -1
      fixed-chunk-inhabited-time: -1
      flush-regions-on-save: false
      max-auto-save-chunks-per-tick: 24
      prevent-moving-into-unloaded-chunks: false
    collisions:
      allow-player-cramming-damage: false
      allow-vehicle-collisions: true
      fix-climbing-bypassing-cramming-rule: false
      max-entity-collisions: 8
      only-players-collide: false
    command-blocks:
      force-follow-perm-level: true
      permissions-level: 2
    entities:
      armor-stands:
        do-collision-entity-lookups: true
        tick: true
      behavior:
        allow-spider-world-border-climbing: true
        baby-zombie-movement-modifier: 0.5
        disable-chest-cat-detection: false
        disable-creeper-lingering-effect: false
        disable-player-crits: false
        door-breaking-difficulty:
          husk:
          - HARD
          vindicator:
          - NORMAL
          - HARD
          zombie:
          - HARD
          zombie_villager:
          - HARD
          zombified_piglin:
          - HARD
        ender-dragons-death-always-places-dragon-egg: false
        experience-merge-max-value: -1
        mobs-can-always-pick-up-loot:
          skeletons: false
          zombies: false
        nerf-pigmen-from-nether-portals: false
        parrots-are-unaffected-by-player-movement: false
        phantoms-do-not-spawn-on-creative-players: true
        phantoms-only-attack-insomniacs: true
        phantoms-spawn-attempt-max-seconds: 119
        phantoms-spawn-attempt-min-seconds: 60
        piglins-guard-chests: true
        pillager-patrols:
          disable: false
          spawn-chance: 0.2
          spawn-delay:
            per-player: false
            ticks: 12000
          start:
            day: 5
            per-player: false
        player-insomnia-start-ticks: 72000
        should-remove-dragon: false
        spawner-nerfed-mobs-should-jump: false
        zombie-villager-infection-chance: default
        zombies-target-turtle-eggs: true
      entities-target-with-follow-range: false
      markers:
        tick: true
      mob-effects:
        immune-to-wither-effect:
          wither: true
          wither-skeleton: true
        spiders-immune-to-poison-effect: true
      sniffer:
        boosted-hatch-time: default
        hatch-time: default
      spawning:
        all-chunks-are-slime-chunks: false
        alt-item-despawn-rate:
          enabled: false
          items:
            cobblestone: 300
        count-all-mobs-for-spawning: false
        creative-arrow-despawn-rate: default
        despawn-ranges:
          ambient:
            hard: 128
            soft: 32
          axolotls:
            hard: 128
            soft: 32
          creature:
            hard: 128
            soft: 32
          misc:
            hard: 128
            soft: 32
          monster:
            hard: 128
            soft: 32
          underground_water_creature:
            hard: 128
            soft: 32
          water_ambient:
            hard: 64
            soft: 32
          water_creature:
            hard: 128
            soft: 32
        disable-mob-spawner-spawn-egg-transformation: false
        duplicate-uuid:
          mode: SAFE_REGEN
          safe-regen-delete-range: 32
        filter-bad-tile-entity-nbt-from-falling-blocks: true
        filtered-entity-tag-nbt-paths:
        - Pos
        - Motion
        - SleepingX
        - SleepingY
        - SleepingZ
        iron-golems-can-spawn-in-air: false
        monster-spawn-max-light-level: default
        non-player-arrow-despawn-rate: default
        per-player-mob-spawns: true
        scan-for-legacy-ender-dragon: true
        skeleton-horse-thunder-spawn-chance: default
        slime-spawn-height:
          slime-chunk:
            maximum: 40.0
          surface-biome:
            maximum: 70.0
            minimum: 50.0
        spawn-limits:
          ambient: -1
          axolotls: -1
          creature: -1
          monster: -1
          underground_water_creature: -1
          water_ambient: -1
          water_creature: -1
        ticks-per-spawn:
          ambient: -1
          axolotls: -1
          creature: -1
          monster: -1
          underground_water_creature: -1
          water_ambient: -1
          water_creature: -1
        wandering-trader:
          spawn-chance-failure-increment: 25
          spawn-chance-max: 75
          spawn-chance-min: 25
          spawn-day-length: 24000
          spawn-minute-length: 1200
        wateranimal-spawn-height:
          maximum: default
          minimum: default
      tracking-range-y:
        animal: default
        display: default
        enabled: false
        misc: default
        monster: default
        other: default
        player: default
    environment:
      disable-explosion-knockback: false
      disable-ice-and-snow: false
      disable-teleportation-suffocation-check: false
      disable-thunder: false
      fire-tick-delay: 30
      frosted-ice:
        delay:
          max: 40
          min: 20
        enabled: true
      generate-flat-bedrock: false
      locate-structures-outside-world-border: false
      max-block-ticks: 65536
      max-fluid-ticks: 65536
      nether-ceiling-void-damage-height: disabled
      optimize-explosions: false
      portal-create-radius: 16
      portal-search-radius: 128
      portal-search-vanilla-dimension-scaling: true
      treasure-maps:
        enabled: true
        find-already-discovered:
          loot-tables: default
          villager-trade: false
      water-over-lava-flow-speed: 5
    feature-seeds:
      generate-random-seeds-for-all: false
    fishing-time-range:
      maximum: 600
      minimum: 100
    fixes:
      disable-unloaded-chunk-enderpearl-exploit: true
      falling-block-height-nerf: disabled
      fix-items-merging-through-walls: false
      prevent-tnt-from-moving-in-water: false
      split-overstacked-loot: true
      tnt-entity-height-nerf: disabled
    hopper:
      cooldown-when-full: true
      disable-move-event: false
      ignore-occluding-blocks: false
    lootables:
      auto-replenish: false
      max-refills: -1
      refresh-max: 2d
      refresh-min: 12h
      reset-seed-on-fill: true
      restrict-player-reloot: true
      restrict-player-reloot-time: disabled
    maps:
      item-frame-cursor-limit: 128
      item-frame-cursor-update-interval: 10
    max-growth-height:
      bamboo:
        max: 16
        min: 11
      cactus: 3
      reeds: 3
    misc:
      disable-end-credits: false
      disable-relative-projectile-velocity: false
      disable-sprint-interruption-on-attack: false
      light-queue-size: 20
      max-leash-distance: 10.0
      redstone-implementation: VANILLA
      shield-blocking-delay: 5
      show-sign-click-command-failure-msgs-to-player: false
      update-pathfinding-on-block-update: true
    scoreboards:
      allow-non-player-entities-on-scoreboards: true
      use-vanilla-world-scoreboard-name-coloring: false
    spawn:
      allow-using-signs-inside-spawn-protection: false
    tick-rates:
      behavior:
        villager:
          validatenearbypoi: -1
      container-update: 1
      dry-farmland: 1
      grass-spread: 1
      mob-spawner: 1
      sensor:
        villager:
          secondarypoisensor: 40
      wet-farmland: 1
    unsupported-settings:
      disable-world-ticking-when-empty: false
      fix-invulnerable-end-crystal-exploit: true
}