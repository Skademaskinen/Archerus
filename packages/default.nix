inputs:

with builtins;

{
    "${inputs.system}" = listToAttrs (map (name: {
        name = name;
        value = import (toPath "${./.}/${name}") inputs;
    }) [
        "testSystem"
        "bolt"
        "plymouth-theme"
        "plymouth-theme-default"
        "wine-discord-ipc-bridge"
        "lsfg-vk"
        "curseforge"
    ]);
}
