{lib, ...}: let
    tools = import ../tools.nix { lib = lib; };
in opts: with opts; with tools; ''
    cat > $out/share/paper-world-defaults.yml << EOF
_version: ${parseValue _version}
anticheat:
  anti-xray:
    enabled: ${parseValue anticheat.anti-xray.enabled}
    engine-mode: ${parseValue anticheat.anti-xray.engine-mode}
    hidden-blocks: ${convert-list-to-yml anticheat.anti-xray.hidden-blocks 6}
    lava-obscures: ${parseValue anticheat.anti-xray.lava-obscures}
    max-block-height: ${parseValue anticheat.anti-xray.max-block-height}
    replacement-blocks: ${convert-list-to-yml anticheat.anti-xray.replacement-blocks 6}
    update-radius: ${parseValue anticheat.anti-xray.update-radius}
    use-permission: ${parseValue anticheat.anti-xray.use-permission}
  obfuscation:
    items:
      hide-durability: ${parseValue anticheat.obfuscation.items.hide-durability}
      hide-itemmeta: ${parseValue anticheat.obfuscation.items.hide-itemmeta}
      hide-itemmeta-with-visual-effects: ${parseValue anticheat.obfuscation.items.hide-itemmeta-with-visual-effects}
chunks:
  auto-save-interval: ${chunks.auto-save-interval}
  delay-chunk-unloads-by: ${chunks.delay-chunk-unloads-by}
  entity-per-chunk-save-limit:
    arrow: ${parseValue chunks.entity-per-chunk-save-limit.arrow}
    ender_pearl: ${parseValue chunks.entity-per-chunk-save-limit.ender_pearl}
    experience_orb: ${parseValue chunks.entity-per-chunk-save-limit.experience_orb}
    fireball: ${parseValue chunks.entity-per-chunk-save-limit.fireball}
    small_fireball: ${parseValue chunks.entity-per-chunk-save-limit.small_fireball}
    snowball: ${parseValue chunks.entity-per-chunk-save-limit.snowball}
  fixed-chunk-inhabited-time: ${parseValue chunks.fixed-chunk-inhabited-time}
  flush-regions-on-save: ${parseValue chunks.flush-regions-on-save}
  max-auto-save-chunks-per-tick: ${parseValue chunks.max-auto-save-chunks-per-tick}
  prevent-moving-into-unloaded-chunks: ${parseValue chunks.prevent-moving-into-unloaded-chunks}
collisions:
  allow-player-cramming-damage: ${parseValue collisions.allow-player-cramming-damage}
  allow-vehicle-collisions: ${parseValue collisions.allow-vehicle-collisions}
  fix-climbing-bypassing-cramming-rule: ${parseValue collisions.fix-climbing-bypassing-cramming-rule}
  max-entity-collisions: ${parseValue collisions.max-entity-collisions}
  only-players-collide: ${parseValue collisions.only-players-collide}
command-blocks:
  force-follow-perm-level: ${parseValue command-blocks.force-follow-perm-level}
  permissions-level: ${parseValue command-blocks.permissions-level}
entities:
  armor-stands:
    do-collision-entity-lookups: ${parseValue entities.armor-stands.do-collision-entity-lookups}
    tick: ${parseValue entities.armor-stands.do-collision-entity-lookups}
  behavior:
    allow-spider-world-border-climbing: ${parseValue entities.behavior.allow-spider-world-border-climbing}
    baby-zombie-movement-modifier: ${parseValue entities.behavior.baby-zombie-movement-modifier}
    disable-chest-cat-detection: ${parseValue entities.behavior.disable-chest-cat-detection}
    disable-creeper-lingering-effect: ${parseValue entities.behavior.disable-creeper-lingering-effect}
    disable-player-crits: ${parseValue entities.behavior.disable-player-crits}
    door-breaking-difficulty:
      husk: ${convert-list-to-yml entities.behavior.door-breaking-difficulty.husk 8}
      vindicator: ${convert-list-to-yml entities.behavior.door-breaking-difficulty.vindicator 8}
      zombie: ${convert-list-to-yml entities.behavior.door-breaking-difficulty.zombie 8}
      zombie_villager: ${convert-list-to-yml entities.behavior.door-breaking-difficulty.zombie_villager 8}
      zombified_piglin: ${convert-list-to-yml entities.behavior.door-breaking-difficulty.zombified_piglin 8}
    ender-dragons-death-always-places-dragon-egg: ${parseValue entities.behavior.ender-dragons-death-always-places-dragon-egg}
    experience-merge-max-value: ${parseValue entities.behavior.experience-merge-max-value}
    mobs-can-always-pick-up-loot:
      skeletons: ${parseValue entities.behavior.mobs-can-always-pick-up-loot.skeletons}
      zombies: ${parseValue entities.behavior.mobs-can-always-pick-up-loot.zombies}
    nerf-pigmen-from-nether-portals: ${parseValue entities.behavior.nerf-pigmen-from-nether-portals}
    parrots-are-unaffected-by-player-movement: ${parseValue entities.behavior.parrots-are-unaffected-by-player-movement}
    phantoms-do-not-spawn-on-creative-players: ${parseValue entities.behavior.phantoms-do-not-spawn-on-creative-players}
    phantoms-only-attack-insomniacs: ${parseValue entities.behavior.phantoms-only-attack-insomniacs}
    phantoms-spawn-attempt-max-seconds: ${parseValue entities.behavior.phantoms-spawn-attempt-max-seconds}
    phantoms-spawn-attempt-min-seconds: ${parseValue entities.behavior.phantoms-spawn-attempt-min-seconds}
    piglins-guard-chests: ${parseValue entities.behavior.piglins-guard-chests}
    pillager-patrols:
      disable: ${parseValue entities.behavior.pillager-patrols.disable}
      spawn-chance: ${parseValue entities.behavior.pillager-patrols.spawn-chance}
      spawn-delay:
        per-player: ${parseValue entities.behavior.pillager-patrols.spawn-delay.per-player}
        ticks: ${parseValue entities.behavior.pillager-patrols.spawn-delay.ticks}
      start:
        day: ${parseValue entities.behavior.pillager-patrols.start.day}
        per-player: ${parseValue entities.behavior.pillager-patrols.start.per-player}
    player-insomnia-start-ticks: ${parseValue entities.behavior.player-insomnia-start-ticks}
    should-remove-dragon: ${parseValue entities.behavior.should-remove-dragon}
    spawner-nerfed-mobs-should-jump: ${parseValue entities.behavior.spawner-nerfed-mobs-should-jump}
    zombie-villager-infection-chance: ${entities.behavior.zombie-villager-infection-chance}
    zombies-target-turtle-eggs: ${parseValue entities.behavior.zombies-target-turtle-eggs}
  entities-target-with-follow-range: ${parseValue entities.entities-target-with-follow-range}
  markers:
    tick: ${parseValue entities.markers.tick}
  mob-effects:
    immune-to-wither-effect:
      wither: ${parseValue entities.mob-effects.immune-to-wither-effect.wither}
      wither-skeleton: ${parseValue entities.mob-effects.immune-to-wither-effect.wither-skeleton}
    spiders-immune-to-poison-effect: ${parseValue entities.mob-effects.spiders-immune-to-poison-effect}
  sniffer:
    boosted-hatch-time: ${entities.sniffer.boosted-hatch-time}
    hatch-time: ${entities.sniffer.hatch-time}
  spawning:
    all-chunks-are-slime-chunks: ${parseValue entities.spawning.all-chunks-are-slime-chunks}
    alt-item-despawn-rate:
      enabled: ${parseValue entities.spawning.alt-item-despawn-rate.enabled}
      items:
        cobblestone: ${parseValue entities.spawning.alt-item-despawn-rate.items.cobblestone}
    count-all-mobs-for-spawning: ${parseValue entities.spawning.count-all-mobs-for-spawning}
    creative-arrow-despawn-rate: ${entities.spawning.creative-arrow-despawn-rate}
    despawn-ranges:
      ambient:
        hard: ${parseValue entities.spawning.despawn-ranges.ambient.hard}
        soft: ${parseValue entities.spawning.despawn-ranges.ambient.soft}
      axolotls:
        hard: ${parseValue entities.spawning.despawn-ranges.axolotls.hard}
        soft: ${parseValue entities.spawning.despawn-ranges.axolotls.soft}
      creature:
        hard: ${parseValue entities.spawning.despawn-ranges.creature.hard}
        soft: ${parseValue entities.spawning.despawn-ranges.creature.soft}
      misc:
        hard: ${parseValue entities.spawning.despawn-ranges.misc.hard}
        soft: ${parseValue entities.spawning.despawn-ranges.misc.soft}
      monster:
        hard: ${parseValue entities.spawning.despawn-ranges.monster.hard}
        soft: ${parseValue entities.spawning.despawn-ranges.monster.soft}
      underground_water_creature:
        hard: ${parseValue entities.spawning.despawn-ranges.underground_water_creature.hard}
        soft: ${parseValue entities.spawning.despawn-ranges.underground_water_creature.soft}
      water_ambient:
        hard: ${parseValue entities.spawning.despawn-ranges.water_ambient.hard}
        soft: ${parseValue entities.spawning.despawn-ranges.water_ambient.soft}
      water_creature:
        hard: ${parseValue entities.spawning.despawn-ranges.water_creature.hard}
        soft: ${parseValue entities.spawning.despawn-ranges.water_creature.soft}
    disable-mob-spawner-spawn-egg-transformation: ${parseValue entities.spawning.disable-mob-spawner-spawn-egg-transformation}
    duplicate-uuid:
      mode: ${entities.spawning.duplicate-uuid.mode}
      safe-regen-delete-range: ${parseValue entities.spawning.duplicate-uuid.safe-regen-delete-range}
    filter-bad-tile-entity-nbt-from-falling-blocks: ${parseValue entities.spawning.filter-bad-tile-entity-nbt-from-falling-blocks}
    filtered-entity-tag-nbt-paths: ${convert-list-to-yml entities.spawning.filtered-entity-tag-nbt-paths 6}
    iron-golems-can-spawn-in-air: ${parseValue entities.spawning.iron-golems-can-spawn-in-air}
    monster-spawn-max-light-level: ${entities.spawning.monster-spawn-max-light-level}
    non-player-arrow-despawn-rate: ${entities.spawning.non-player-arrow-despawn-rate}
    per-player-mob-spawns: ${parseValue entities.spawning.per-player-mob-spawns}
    scan-for-legacy-ender-dragon: ${parseValue entities.spawning.scan-for-legacy-ender-dragon}
    skeleton-horse-thunder-spawn-chance: ${entities.spawning.skeleton-horse-thunder-spawn-chance}
    slime-spawn-height:
      slime-chunk:
        maximum: ${parseValue entities.spawning.slime-spawn-height.slime-chunk.maximum}
      surface-biome:
        maximum: ${parseValue entities.spawning.slime-spawn-height.surface-biome.maximum}
        minimum: ${parseValue entities.spawning.slime-spawn-height.surface-biome.minimum}
    spawn-limits:
      ambient: ${parseValue entities.spawning.spawn-limits.ambient}
      axolotls: ${parseValue entities.spawning.spawn-limits.axolotls}
      creature: ${parseValue entities.spawning.spawn-limits.creature}
      monster: ${parseValue entities.spawning.spawn-limits.monster}
      underground_water_creature: ${parseValue entities.spawning.spawn-limits.underground_water_creature}
      water_ambient: ${parseValue entities.spawning.spawn-limits.water_ambient}
      water_creature: ${parseValue entities.spawning.spawn-limits.water_creature}
    ticks-per-spawn:
      ambient: ${parseValue entities.spawning.ticks-per-spawn.ambient}
      axolotls: ${parseValue entities.spawning.ticks-per-spawn.axolotls}
      creature: ${parseValue entities.spawning.ticks-per-spawn.creature}
      monster: ${parseValue entities.spawning.ticks-per-spawn.monster}
      underground_water_creature: ${parseValue entities.spawning.ticks-per-spawn.underground_water_creature}
      water_ambient: ${parseValue entities.spawning.ticks-per-spawn.water_ambient}
      water_creature: ${parseValue entities.spawning.ticks-per-spawn.water_creature}
    wandering-trader:
      spawn-chance-failure-increment: ${parseValue entities.spawning.wandering-trader.spawn-chance-failure-increment}
      spawn-chance-max: ${parseValue entities.spawning.wandering-trader.spawn-chance-max}
      spawn-chance-min: ${parseValue entities.spawning.wandering-trader.spawn-chance-min}
      spawn-day-length: ${parseValue entities.spawning.wandering-trader.spawn-day-length}
      spawn-minute-length: ${parseValue entities.spawning.wandering-trader.spawn-minute-length}
    wateranimal-spawn-height:
      maximum: ${entities.spawning.wateranimal-spawn-height.maximum}
      minimum: ${entities.spawning.wateranimal-spawn-height.minimum}
  tracking-range-y:
    animal: ${entities.tracking-range-y.animal}
    display: ${entities.tracking-range-y.display}
    enabled: ${parseValue entities.tracking-range-y.enabled}
    misc: ${entities.tracking-range-y.misc}
    monster: ${entities.tracking-range-y.monster}
    other: ${entities.tracking-range-y.other}
    player: ${entities.tracking-range-y.player}
environment:
  disable-explosion-knockback: ${parseValue environment.disable-explosion-knockback}
  disable-ice-and-snow: ${parseValue environment.disable-ice-and-snow}
  disable-teleportation-suffocation-check: ${parseValue environment.disable-teleportation-suffocation-check}
  disable-thunder: ${parseValue environment.disable-thunder}
  fire-tick-delay: ${parseValue environment.fire-tick-delay}
  frosted-ice:
    delay:
      max: ${parseValue environment.frosted-ice.delay.max}
      min: ${parseValue environment.frosted-ice.delay.min}
    enabled: ${parseValue environment.frosted-ice.enabled}
  generate-flat-bedrock: ${parseValue environment.generate-flat-bedrock}
  locate-structures-outside-world-border: ${parseValue environment.locate-structures-outside-world-border}
  max-block-ticks: ${parseValue environment.max-block-ticks}
  max-fluid-ticks: ${parseValue environment.max-fluid-ticks}
  nether-ceiling-void-damage-height: ${environment.nether-ceiling-void-damage-height}
  optimize-explosions: ${parseValue environment.optimize-explosions}
  portal-create-radius: ${parseValue environment.portal-create-radius}
  portal-search-radius: ${parseValue environment.portal-search-radius}
  portal-search-vanilla-dimension-scaling: ${parseValue environment.portal-search-vanilla-dimension-scaling}
  treasure-maps:
    enabled: ${parseValue environment.treasure-maps.enabled}
    find-already-discovered:
      loot-tables: ${environment.treasure-maps.find-already-discovered.loot-tables}
      villager-trade: ${parseValue environment.treasure-maps.find-already-discovered.villager-trade}
  water-over-lava-flow-speed: ${parseValue environment.water-over-lava-flow-speed}
feature-seeds:
  generate-random-seeds-for-all: ${parseValue feature-seeds.generate-random-seeds-for-all}
fishing-time-range:
  maximum: ${parseValue fishing-time-range.maximum}
  minimum: ${parseValue fishing-time-range.minimum}
fixes:
  disable-unloaded-chunk-enderpearl-exploit: ${parseValue fixes.disable-unloaded-chunk-enderpearl-exploit}
  falling-block-height-nerf: ${fixes.falling-block-height-nerf}
  fix-items-merging-through-walls: ${parseValue fixes.fix-items-merging-through-walls}
  prevent-tnt-from-moving-in-water: ${parseValue fixes.prevent-tnt-from-moving-in-water}
  split-overstacked-loot: ${parseValue fixes.split-overstacked-loot}
  tnt-entity-height-nerf: ${fixes.tnt-entity-height-nerf}
hopper:
  cooldown-when-full: ${parseValue hopper.cooldown-when-full}
  disable-move-event: ${parseValue hopper.disable-move-event}
  ignore-occluding-blocks: ${parseValue hopper.ignore-occluding-blocks}
lootables:
  auto-replenish: ${parseValue lootables.auto-replenish}
  max-refills: ${parseValue lootables.max-refills}
  refresh-max: ${lootables.refresh-max}
  refresh-min: ${lootables.refresh-min}
  reset-seed-on-fill: ${parseValue lootables.reset-seed-on-fill}
  restrict-player-reloot: ${parseValue lootables.restrict-player-reloot}
  restrict-player-reloot-time: ${parseValue lootables.restrict-player-reloot-time}
maps:
  item-frame-cursor-limit: ${parseValue maps.item-frame-cursor-limit}
  item-frame-cursor-update-interval: ${parseValue maps.item-frame-cursor-update-interval}
max-growth-height:
  bamboo:
    max: ${parseValue max-growth-height.bamboo.max}
    min: ${parseValue max-growth-height.bamboo.min}
  cactus: ${parseValue max-growth-height.cactus}
  reeds: ${parseValue max-growth-height.reeds}
misc:
  disable-end-credits: ${parseValue misc.disable-end-credits}
  disable-relative-projectile-velocity: ${parseValue misc.disable-relative-projectile-velocity}
  disable-sprint-interruption-on-attack: ${parseValue misc.disable-sprint-interruption-on-attack}
  light-queue-size: ${parseValue misc.light-queue-size}
  max-leash-distance: ${parseValue misc.max-leash-distance}
  redstone-implementation: ${misc.redstone-implementation}
  shield-blocking-delay: ${parseValue misc.shield-blocking-delay}
  show-sign-click-command-failure-msgs-to-player: ${parseValue misc.show-sign-click-command-failure-msgs-to-player}
  update-pathfinding-on-block-update: ${parseValue misc.update-pathfinding-on-block-update}
scoreboards:
  allow-non-player-entities-on-scoreboards: ${parseValue scoreboards.allow-non-player-entities-on-scoreboards}
  use-vanilla-world-scoreboard-name-coloring: ${parseValue scoreboards.use-vanilla-world-scoreboard-name-coloring}
spawn:
  allow-using-signs-inside-spawn-protection: ${parseValue spawn.allow-using-signs-inside-spawn-protection}
tick-rates:
  behavior:
    villager:
      validatenearbypoi: ${parseValue tick-rates.behavior.villager.validatenearbypoi}
  container-update: ${parseValue tick-rates.container-update}
  dry-farmland: ${parseValue tick-rates.dry-farmland}
  grass-spread: ${parseValue tick-rates.grass-spread}
  mob-spawner: ${parseValue tick-rates.mob-spawner}
  sensor:
    villager:
      secondarypoisensor: ${parseValue tick-rates.sensor.villager.secondarypoisensor}
  wet-farmland: ${parseValue tick-rates.wet-farmland}
unsupported-settings:
  disable-world-ticking-when-empty: ${parseValue unsupported-settings.disable-world-ticking-when-empty}
  fix-invulnerable-end-crystal-exploit: ${parseValue unsupported-settings.fix-invulnerable-end-crystal-exploit}
EOF
''