{ lib, nixpkgs, ...}:

# This builder will automatically check the current directory for files ending in .nix or a default.nix.
# if one is found, a module representing the path is generated.

let
    pkgs = lib.load nixpkgs;

    discoverModules = basePath: modulePath:
        let
            entries = builtins.readDir (basePath + "/${pkgs.lib.concatStringsSep "/" modulePath}");
        in
            if builtins.hasAttr "default.nix" entries then
                # if default.nix exists, import it and stop
                lib.load (basePath + "/${pkgs.lib.concatStringsSep "/" modulePath}/default.nix")
            else
                pkgs.lib.foldl' (acc: name:
                    let
                        fullPath = modulePath ++ [ name ];
                        pathStr  = pkgs.lib.concatStringsSep "/" fullPath;
                        isDir    = entries.${name} == "directory";
                        isFile   = entries.${name} == "regular";
                    in
                        if isDir then
                            acc // {
                                ${pkgs.lib.removeSuffix "/" name} =
                                    discoverModules basePath fullPath;
                            }
                        else if pkgs.lib.hasSuffix ".nix" name then
                            acc // {
                                ${pkgs.lib.removeSuffix ".nix" name} =
                                    lib.load (basePath + "/${pathStr}");
                            }
                        else
                            acc
                ) { } (builtins.attrNames entries);

in basePath:
    discoverModules basePath []

