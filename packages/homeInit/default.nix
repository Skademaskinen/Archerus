# this is for generating a home-manager flake for easy deployment
{ lib, nixpkgs, ... }:

let
    pkgs = lib.load nixpkgs;
in

pkgs.writeScriptBin "homeInit" ''
    #!${pkgs.python312}/bin/python
    from sys import argv
    from os import system, path, mkdir, environ
    if len(argv) == 1:
        username = environ["USER"]
    else:
        username = argv[-1]
    home = environ["HOME"]

    print(f"Writing to {home}/.config/home-manager/flake.nix")
    flake = f"""
    {{
        inputs.archerus.url = "github:Skademaskinen/Archerus";
        outputs = inputs: {{
            homeConfigurations.{username} = inputs.archerus.homeConfigurations.default "{username}";
        }};
    }}
    """
    for directory in [f"{home}/.config", f"{home}/.config/home-manager"]:
        if not path.exists(directory):
            mkdir(directory)
    with open(f"{home}/.config/home-manager/flake.nix", "w") as home_manager_flake:
        home_manager_flake.write(flake)
''
