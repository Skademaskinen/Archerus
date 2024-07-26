{lib, ...}: with lib.types; let
    tools = import ../tools.nix { lib = lib; };
in with tools; {
    settings = {
        allow-end = tbool;
        warn-on-overload = tbool;
        permissions-file = stropt "permissions.yml";
        update-folder = stropt "update";
        plugin-profiling = fbool;
        connection-throttle = intopt 4000;
        query-plugins = tbool;
        deprecated-verbose = stropt "default";
        shutdown-message = stropt "Server closed";
        minimum-api = stropt "none";
        use-map-color-cache = tbool;
    };
    spawn-limits = {
        monsters = intopt 70;
        animals = intopt 10;
        water-animals = intopt 5;
        water-ambient = intopt 20;
        water-underground-creature = intopt 5;
        axolotls = intopt 5;
        ambient = intopt 15;
    };
    chunk-gc = {
      period-in-ticks = intopt 600;
    };
    ticks-per = {
        animal-spawns = intopt 400;
        monster-spawns = intopt 1;
        water-spawns = intopt 1;
        water-ambient-spawns = intopt 1;
        water-underground-creature-spawns = intopt 1;
        axolotl-spawns = intopt 1;
        ambient-spawns = intopt 1;
        autosave = intopt 6000;
    };
    aliases = stropt "now-in-commands.yml";
}