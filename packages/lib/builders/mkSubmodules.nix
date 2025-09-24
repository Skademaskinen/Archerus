{ lib, ...} @ inputs:

args:

builtins.listToAttrs (map (path: {
    name = lib.removeExtension ".nix" (builtins.baseNameOf path);
    value = import path (inputs // { inherit lib; });
}) args)
