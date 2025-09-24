{ nixpkgs, lib, ... }:

string: let
    words = nixpkgs.lib.strings.splitString " " string;
    capitalizedWords = builtins.map (word:
        (nixpkgs.lib.strings.toUpper (builtins.substring 0 1 word)) + lib.stringTail word 1
    ) words;
in builtins.concatStringsSep " " capitalizedWords
