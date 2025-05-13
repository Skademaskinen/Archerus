inputs:

with builtins;

listToAttrs (map (name: {
    name = name;
    value = import (toPath "${./.}/${name}") inputs;
}) [
    "common"
    "desktop"
    "gaming"
    "server"
    "grub"
    "plymouth"
])
