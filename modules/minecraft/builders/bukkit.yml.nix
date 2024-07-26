
{lib, ...}: let
    tools = import ../tools.nix { lib = lib; };
in bukkit-options: with bukkit-options; with tools; ''
cat > $out/share/bukkit.yml << EOF
    settings:
      allow-end: ${parseValue settings.allow-end}
      warn-on-overload: ${parseValue settings.warn-on-overload}
      permissions-file: ${settings.permissions-file}
      update-folder: ${settings.update-folder}
      plugin-profiling: ${parseValue settings.plugin-profiling}
      connection-throttle: ${parseValue settings.connection-throttle}
      query-plugins: ${parseValue settings.query-plugins}
      deprecated-verbose: ${settings.deprecated-verbose}
      shutdown-message: ${settings.shutdown-message}
      minimum-api: ${settings.minimum-api}
      use-map-color-cache: ${parseValue settings.use-map-color-cache}
    spawn-limits:
      monsters: ${parseValue spawn-limits.monsters}
      animals: ${parseValue spawn-limits.animals}
      water-animals: ${parseValue spawn-limits.water-animals}
      water-ambient: ${parseValue spawn-limits.water-ambient}
      water-underground-creature: ${parseValue spawn-limits.water-underground-creature}
      axolotls: ${parseValue spawn-limits.axolotls}
      ambient: ${parseValue spawn-limits.ambient}
    chunk-gc:
      period-in-ticks: 6${parseValue chunk-gc.period-in-ticks}
    ticks-per:
      animal-spawns: ${parseValue ticks-per.animal-spawns}
      monster-spawns: ${parseValue ticks-per.monster-spawns}
      water-spawns: ${parseValue ticks-per.water-spawns}
      water-ambient-spawns: ${parseValue ticks-per.water-ambient-spawns}
      water-underground-creature-spawns: ${parseValue ticks-per.water-underground-creature-spawns}
      axolotl-spawns: ${parseValue ticks-per.axolotl-spawns}
      ambient-spawns: ${parseValue ticks-per.ambient-spawns}
      autosave: ${parseValue ticks-per.autosave}
    aliases: ${aliases}
EOF
''