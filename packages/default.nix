inputs:

with builtins;

{
    "${inputs.system}" = listToAttrs (map (name: {
        name = name;
        value = import (toPath "${./.}/${name}") inputs;
    }) [
        "testSystem"
        "bolt"
    ]);
}
