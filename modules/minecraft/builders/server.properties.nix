{lib, ...}: let
    tools = import ../tools.nix { lib = lib; };
in opts: with opts; with tools; ''
cat > $out/share/server.properties << EOF
    accepts-transfers=${parseValue accepts-transfers}
    allow-flight=${parseValue allow-flight}
    allow-nether=${parseValue allow-nether}
    broadcast-console-to-ops=${parseValue broadcast-console-to-ops}
    broadcast-rcon-to-ops=${parseValue broadcast-rcon-to-ops}
    debug=${parseValue debug}
    difficulty=${difficulty}
    enable-command-block=${parseValue enable-command-block}
    enable-jmx-monitoring=${parseValue enable-jmx-monitoring}
    enable-query=${parseValue enable-query}
    enable-rcon=${parseValue enable-rcon}
    enable-status=${parseValue enable-status}
    enforce-secure-profile=${parseValue enforce-secure-profile}
    enforce-whitelist=${parseValue enforce-whitelist}
    entity-broadcast-range-percentage=${parseValue entity-broadcast-range-percentage}
    force-gamemode=${parseValue force-gamemode}
    function-permission-level=${parseValue function-permission-level}
    gamemode=${gamemode}
    generate-structures=${parseValue generate-structures}
    hardcore=${parseValue hardcore}
    hide-online-players=${parseValue hide-online-players}
    initial-enabled-packs=${initial-enabled-packs}
    level-name=${level-name}
    level-seed=${level-seed}
    level-type=${level-type}
    log-ips=${parseValue log-ips}
    max-chained-neighbor-updates=${parseValue max-chained-neighbor-updates}
    max-players=${parseValue max-players}
    max-tick-time=${parseValue max-tick-time}
    max-world-size=${parseValue max-world-size}
    motd=${motd}
    network-compression-threshold=${parseValue network-compression-threshold}
    online-mode=${parseValue online-mode}
    op-permission-level=${parseValue op-permission-level}
    player-idle-timeout=${parseValue player-idle-timeout}
    prevent-proxy-connections=${parseValue prevent-proxy-connections}
    pvp=${parseValue pvp}
    query.port=${parseValue query.port}
    rate-limit=${parseValue rate-limit}
    rcon.password=${rcon.password}
    rcon.port=${parseValue rcon.port}
    region-file-compression=${region-file-compression}
    require-resource-pack=${parseValue require-resource-pack}
    server-ip=${server-ip}
    server-port=${parseValue server-port}
    simulation-distance=${parseValue simulation-distance}
    spawn-animals=${parseValue spawn-animals}
    spawn-monsters=${parseValue spawn-monsters}
    spawn-npcs=${parseValue spawn-npcs}
    spawn-protection=${parseValue spawn-protection}
    sync-chunk-writes=${parseValue sync-chunk-writes}
    use-native-transport=${parseValue use-native-transport}
    view-distance=${parseValue view-distance}
    white-list=${parseValue white-list}
EOF
''