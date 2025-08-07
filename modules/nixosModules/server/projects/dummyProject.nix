{ lib, ... }:

{ pkgs, config, ...}:

let
    dummy = pkgs.writeScriptBin "dummyProject" ''
        #!${(pkgs.python312.withPackages (py: with py; [])).interpreter}
        import os
        print("Running service...")
        setting = os.environ["DUMMY_VARIABLE"]
        print(f"Setting: {setting}")
        while True:
            print("Taking input")
            value = input("Write anything: ")
            print(f"Got value: {value}")
    '';
in

{
    options = {

    };
    # import base to avoid having multiple imports
    imports = [
        (lib.iCall ../base.nix)
    ];
    
    config = lib.mkProjectConfig config {
        name = "dummyProject";
        stdinSocket = true;
        exec = "${dummy}/bin/dummyProject";
        environment = {
            DUMMY_VARIABLE = "hello, world!";
        };
    };
}
