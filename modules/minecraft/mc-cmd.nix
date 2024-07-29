{config, pkgs, ...}: pkgs.writeScriptBin "mc-cmd" ''
    if [[ "$1" == "--list" ]]; then
        ls ${config.skademaskinen.storage}/minecraft/sockets
        exit 0
    fi
    echo "Service: $1"
    echo "Command: $2"

    echo "$2" > ${config.skademaskinen.storage}/minecraft/sockets/$1.stdin
''