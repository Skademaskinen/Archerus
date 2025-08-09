inputs:

string: offset:
    builtins.substring offset (builtins.stringLength string) string
