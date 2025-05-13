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

}
