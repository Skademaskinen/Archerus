{ nixpkgs, ... } @ inputs:

rec {
    stringTail = string: offset:
        builtins.substring offset (builtins.stringLength string) string;

    capitalize = string: let
        words = nixpkgs.lib.strings.splitString " " string;
        capitalizedWords = builtins.map (word:
            (nixpkgs.lib.strings.toUpper (builtins.substring 0 1 word)) + stringTail word 1
        ) words;
    in builtins.concatStringsSep " " capitalizedWords;

    wallpapers = import ./wallpapers.nix inputs;

    pruneNixExtension = pathName: builtins.elemAt (builtins.split ".nix" pathName) 0;


    iCall = path: import path (inputs // { lib = inputs.self.lib; });

    pkgs = import nixpkgs { system = inputs.system; };

    baseIf = fallback: condition: value: if condition
        then value
        else fallback;

    setIf = baseIf {};
    strIf = baseIf "";
    fIf = s: v: f: if s ? v then s.${v} else f;
}
