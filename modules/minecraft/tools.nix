{lib}: with lib.types; {
    # reducing character count...
    tbool = lib.mkOption {
        type = bool;
        default = true;
    };
    fbool = lib.mkOption {
        type = bool;
        default = false;
    };
    intopt = v: lib.mkOption {
        type = int;
        default = v;
    };
    fopt = v: lib.mkOption {
        type = float;
        default = v;
    };
    stropt = s: lib.mkOption {
        type = str;
        default = s;
    };
    # slist :: [lib.types.str] -> [lib.types.str]
    slist = v: lib.mkOption {
        type = listOf str;
        default = v;
    };

    parseValue = value: 
        if value == true then 
            "true" 
        else if value == false then 
            "false" 
        else 
            builtins.toString value;

    convert-list-to-yml = let
        make-indent = indent: lib.concatMapStrings (_: " ") (lib.range 1 indent);
    in list: indent: "\n" + (builtins.concatStringsSep "" (map (entry: "${make-indent indent}- ${entry}\n") list));
}