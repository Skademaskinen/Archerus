{lib, ...}: let
    tools = import ../tools.nix { lib = lib; };
in spigot-options: with spigot-options; with tools; ''
cat > $out/share/spigot.yml << EOF
    messages:
      whitelist: ${messages.whitelist}
      unknown-command: ${messages.unknown-command}
      server-full: ${messages.server-full}
      outdated-client: ${messages.outdated-client}
      outdated-server: ${messages.outdated-server}
      restart: ${messages.restart}
    advancements:
      disable-saving: ${parseValue advancements.disable-saving}
      disabled: ${convert-list-to-yml advancements.disabled 8}
    settings:
      bungeecord: ${parseValue settings.bungeecord}
      save-user-cache-on-stop-only: ${parseValue settings.save-user-cache-on-stop-only}
      sample-count: ${parseValue settings.sample-count}
      player-shuffle: ${parseValue settings.player-shuffle}
      user-cache-size: ${parseValue settings.user-cache-size}
      moved-wrongly-threshold: ${parseValue settings.moved-wrongly-threshold}
      moved-too-quickly-multiplier: ${parseValue settings.moved-too-quickly-multiplier}
      timeout-time: ${parseValue settings.timeout-time}
      restart-on-crash: ${parseValue settings.restart-on-crash}
      restart-script: ${settings.restart-script}
      netty-threads: ${parseValue settings.netty-threads}
      attribute:
        maxAbsorption:
          max: ${parseValue settings.attribute.maxAbsorption.max}
        maxHealth:
          max: ${parseValue settings.attribute.maxHealth.max}
        movementSpeed:
          max: ${parseValue settings.attribute.movementSpeed.max}
        attackDamage:
          max: ${parseValue settings.attribute.attackDamage.max}
      log-villager-deaths: ${parseValue settings.log-villager-deaths}
      log-named-deaths: ${parseValue settings.log-named-deaths}
      debug: ${parseValue settings.debug}
    commands:
      tab-complete: ${parseValue commands.tab-complete}
      send-namespaced: ${parseValue commands.send-namespaced}
      log: ${parseValue commands.log}
      spam-exclusions: ${convert-list-to-yml commands.spam-exclusions 8}
      silent-commandblock-console: ${parseValue commands.silent-commandblock-console}
      replace-commands: ${convert-list-to-yml commands.replace-commands 8}
    world-settings:
      default:
        below-zero-generation-in-existing-chunks: ${parseValue world-settings.default.below-zero-generation-in-existing-chunks}
        view-distance: ${world-settings.default.view-distance}
        simulation-distance: ${world-settings.default.simulation-distance}
        thunder-chance: ${parseValue world-settings.default.thunder-chance}
        merge-radius:
          item: ${parseValue world-settings.default.merge-radius.item}
          exp: ${parseValue world-settings.default.merge-radius.exp}
        mob-spawn-range: ${parseValue world-settings.default.mob-spawn-range}
        item-despawn-rate: ${parseValue world-settings.default.item-despawn-rate}
        arrow-despawn-rate: ${parseValue world-settings.default.arrow-despawn-rate}
        trident-despawn-rate: ${parseValue world-settings.default.trident-despawn-rate}
        zombie-aggressive-towards-villager: ${parseValue world-settings.default.zombie-aggressive-towards-villager}
        nerf-spawner-mobs: ${parseValue world-settings.default.nerf-spawner-mobs}
        enable-zombie-pigmen-portal-spawns: ${parseValue world-settings.default.enable-zombie-pigmen-portal-spawns}
        wither-spawn-sound-radius: ${parseValue world-settings.default.wither-spawn-sound-radius}
        end-portal-sound-radius: ${parseValue world-settings.default.end-portal-sound-radius}
        hanging-tick-frequency: ${parseValue world-settings.default.hanging-tick-frequency}
        unload-frozen-chunks: ${parseValue world-settings.default.unload-frozen-chunks}
        growth:
          cactus-modifier: ${parseValue world-settings.default.growth.cactus-modifier}
          cane-modifier: ${parseValue world-settings.default.growth.cane-modifier}
          melon-modifier: ${parseValue world-settings.default.growth.melon-modifier}
          mushroom-modifier: ${parseValue world-settings.default.growth.mushroom-modifier}
          pumpkin-modifier: ${parseValue world-settings.default.growth.pumpkin-modifier}
          sapling-modifier: ${parseValue world-settings.default.growth.sapling-modifier}
          beetroot-modifier: ${parseValue world-settings.default.growth.beetroot-modifier}
          carrot-modifier: ${parseValue world-settings.default.growth.carrot-modifier}
          potato-modifier: ${parseValue world-settings.default.growth.potato-modifier}
          torchflower-modifier: ${parseValue world-settings.default.growth.torchflower-modifier}
          wheat-modifier: ${parseValue world-settings.default.growth.wheat-modifier}
          netherwart-modifier: ${parseValue world-settings.default.growth.netherwart-modifier}
          vine-modifier: ${parseValue world-settings.default.growth.vine-modifier}
          cocoa-modifier: ${parseValue world-settings.default.growth.cocoa-modifier}
          bamboo-modifier: ${parseValue world-settings.default.growth.bamboo-modifier}
          sweetberry-modifier: ${parseValue world-settings.default.growth.sweetberry-modifier}
          kelp-modifier: ${parseValue world-settings.default.growth.kelp-modifier}
          twistingvines-modifier: ${parseValue world-settings.default.growth.twistingvines-modifier}
          weepingvines-modifier: ${parseValue world-settings.default.growth.weepingvines-modifier}
          cavevines-modifier: ${parseValue world-settings.default.growth.cavevines-modifier}
          glowberry-modifier: ${parseValue world-settings.default.growth.glowberry-modifier}
          pitcherplant-modifier: ${parseValue world-settings.default.growth.pitcherplant-modifier}
        entity-activation-range:
          animals: ${parseValue world-settings.default.entity-activation-range.animals}
          monsters: ${parseValue world-settings.default.entity-activation-range.monsters}
          raiders: ${parseValue world-settings.default.entity-activation-range.raiders}
          misc: ${parseValue world-settings.default.entity-activation-range.misc}
          water: ${parseValue world-settings.default.entity-activation-range.water}
          villagers: ${parseValue world-settings.default.entity-activation-range.villagers}
          flying-monsters: ${parseValue world-settings.default.entity-activation-range.flying-monsters}
          wake-up-inactive:
            animals-max-per-tick: ${parseValue world-settings.default.entity-activation-range.wake-up-inactive.animals-max-per-tick}
            animals-every: ${parseValue world-settings.default.entity-activation-range.wake-up-inactive.animals-every}
            animals-for: ${parseValue world-settings.default.entity-activation-range.wake-up-inactive.animals-for}
            monsters-max-per-tick: ${parseValue world-settings.default.entity-activation-range.wake-up-inactive.monsters-max-per-tick}
            monsters-every: ${parseValue world-settings.default.entity-activation-range.wake-up-inactive.monsters-every}
            monsters-for: ${parseValue world-settings.default.entity-activation-range.wake-up-inactive.monsters-for}
            villagers-max-per-tick: ${parseValue world-settings.default.entity-activation-range.wake-up-inactive.villagers-max-per-tick}
            villagers-every: ${parseValue world-settings.default.entity-activation-range.wake-up-inactive.villagers-every}
            villagers-for: ${parseValue world-settings.default.entity-activation-range.wake-up-inactive.villagers-for}
            flying-monsters-max-per-tick: ${parseValue world-settings.default.entity-activation-range.wake-up-inactive.flying-monsters-max-per-tick}
            flying-monsters-every: ${parseValue world-settings.default.entity-activation-range.wake-up-inactive.flying-monsters-every}
            flying-monsters-for: ${parseValue world-settings.default.entity-activation-range.wake-up-inactive.flying-monsters-for}
          villagers-work-immunity-after: ${parseValue world-settings.default.entity-activation-range.villagers-work-immunity-after}
          villagers-work-immunity-for: ${parseValue world-settings.default.entity-activation-range.villagers-work-immunity-for}
          villagers-active-for-panic: ${parseValue world-settings.default.entity-activation-range.villagers-active-for-panic}
          tick-inactive-villagers: ${parseValue world-settings.default.entity-activation-range.tick-inactive-villagers}
          ignore-spectators: ${parseValue world-settings.default.entity-activation-range.ignore-spectators}
        entity-tracking-range:
          players: ${parseValue world-settings.default.entity-tracking-range.players}
          animals: ${parseValue world-settings.default.entity-tracking-range.animals}
          monsters: ${parseValue world-settings.default.entity-tracking-range.monsters}
          misc: ${parseValue world-settings.default.entity-tracking-range.misc}
          display: ${parseValue world-settings.default.entity-tracking-range.display}
          other: ${parseValue world-settings.default.entity-tracking-range.other}
        ticks-per:
          hopper-transfer: ${parseValue world-settings.default.ticks-per.hopper-transfer}
          hopper-check: ${parseValue world-settings.default.ticks-per.hopper-check}
        hopper-amount: ${parseValue world-settings.default.hopper-amount}
        hopper-can-load-chunks: ${parseValue world-settings.default.hopper-can-load-chunks}
        dragon-death-sound-radius: ${parseValue world-settings.default.dragon-death-sound-radius}
        seed-village: ${parseValue world-settings.default.seed-village}
        seed-desert: ${parseValue world-settings.default.seed-desert}
        seed-igloo: ${parseValue world-settings.default.seed-igloo}
        seed-jungle: ${parseValue world-settings.default.seed-jungle}
        seed-swamp: ${parseValue world-settings.default.seed-swamp}
        seed-monument: ${parseValue world-settings.default.seed-monument}
        seed-shipwreck: ${parseValue world-settings.default.seed-shipwreck}
        seed-ocean: ${parseValue world-settings.default.seed-ocean}
        seed-outpost: ${parseValue world-settings.default.seed-outpost}
        seed-endcity: ${parseValue world-settings.default.seed-endcity}
        seed-slime: ${parseValue world-settings.default.seed-slime}
        seed-nether: ${parseValue world-settings.default.seed-nether}
        seed-mansion: ${parseValue world-settings.default.seed-mansion}
        seed-fossil: ${parseValue world-settings.default.seed-fossil}
        seed-portal: ${parseValue world-settings.default.seed-portal}
        seed-ancientcity: ${parseValue world-settings.default.seed-ancientcity}
        seed-trailruins: ${parseValue world-settings.default.seed-trailruins}
        seed-trialchambers: ${parseValue world-settings.default.seed-trialchambers}
        seed-buriedtreasure: ${parseValue world-settings.default.seed-buriedtreasure}
        seed-mineshaft: ${world-settings.default.seed-mineshaft}
        seed-stronghold: ${world-settings.default.seed-stronghold}
        hunger:
          jump-walk-exhaustion: ${parseValue world-settings.default.hunger.jump-walk-exhaustion}
          jump-sprint-exhaustion: ${parseValue world-settings.default.hunger.jump-sprint-exhaustion}
          combat-exhaustion: ${parseValue world-settings.default.hunger.combat-exhaustion}
          regen-exhaustion: ${parseValue world-settings.default.hunger.regen-exhaustion}
          swim-multiplier: ${parseValue world-settings.default.hunger.swim-multiplier}
          sprint-multiplier: ${parseValue world-settings.default.hunger.sprint-multiplier}
          other-multiplier: ${parseValue world-settings.default.hunger.other-multiplier}
        max-tnt-per-tick: ${parseValue world-settings.default.max-tnt-per-tick}
        max-tick-time: 
          tile: ${parseValue world-settings.default.max-tick-time.tile}
          entity: ${parseValue world-settings.default.max-tick-time.entity}
        verbose: ${parseValue world-settings.default.verbose}
    players:
      disable-saving: ${parseValue players.disable-saving}
    config-version: ${parseValue config-version}
    stats:
      disable-saving: ${parseValue stats.disable-saving}
      forced-stats: {}
EOF
''