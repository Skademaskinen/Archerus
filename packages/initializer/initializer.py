from sys import argv
from os import mkdir, system, environ, path
from argparse import ArgumentParser
from subprocess import check_output

def init(args):
    path = f"{args.home}/.config/home-manager/flake.nix" if args.type == "home-manager" else "/etc/nixos/flake.nix"
    print(f"Initializing flake in {path}")
    file = "home-manager-flake.nix" if args.type == "home-manager" else "nixos-flake.nix"
    with open(file, "r") as input_flake:
        flake = input_flake.read()
    final_flake = flake.replace("user", args.username).replace("host", args.hostname)
    with open(path, "w") as output_flake:
        output_flake.write(final_flake)

def switch(args):
    print(f"Switching {args.type} configuration")
    system("home-manager switch" if args.type == "home-manager" else "sudo nixos-rebuild switch")

parser = ArgumentParser()
parser.add_argument("--username", default=environ["USER"])
parser.add_argument("--home", default=environ["HOME"])
parser.add_argument("--hostname", default=check_output(["hostname"]).decode())
parser.add_argument("--type", default="home-manager", choices=["home-manager", "nixos"])
parser.add_argument("modes", nargs="+", choices=["init", "switch"])
args = parser.parse_args()

actions = {
    "init": init,
    "switch": switch
}

if args.type == "home-manager":
    for directory in [f"{args.home}/.config", f"{args.home}/.config/home-manager"]:
        if not path.exists(directory):
            mkdir(directory)

for mode in args.modes:
    actions[mode](args)
