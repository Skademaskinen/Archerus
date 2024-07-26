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

    parseValue = value: 
        if value == true then 
            "true" 
        else if value == false then 
            "false" 
        else 
            builtins.toString value;
}