from sys import argv
from os import mkdir, system, environ, path
from argparse import ArgumentParser
from subprocess import check_output

class Initializer:
    def __init__(self, input_path, output_path, executable):
        self.input_path = input_path
        self.output_path = output_path
        self.executable = executable


    def init(self):
        print(f"Initializing flake in {self.output_path}")
        with open(self.input_path, "r") as input_file:
            flake = input_file.read()
        final_flake = self.replace_strings(flake, self.string_pairs())
        with open(self.output_path, "w") as output_file:
            output_file.write(final_flake)
        self.extra_init()

    def switch(self):
        system(f"{self.executable} switch")
    
    def extra_init(self):
        pass

    def replace_strings(self, flake, strings):
        final = flake
        for fst, snd in strings:
            final = final.replace(fst, snd)
        return final

    def string_pairs(self):
        return []

    def execute(self, mode):
        match mode:
            case "init":
                self.init()
            case "switch":
                self.switch()
            case _:
                raise NotImplementedError("No such mode")


class HomeManager(Initializer):
    def __init__(self, home, username):
        self.username = username
        super().__init__("home-manager-flake.nix", f"{home}/.config/home-manager/flake.nix", "home-manager-executable")
        for directory in [f"{home}/.config", f"{home}/.config/home-manager"]:
            if not path.exists(directory):
                mkdir(directory)

    def string_pairs(self):
        return [("user", self.username)]

    def extras(self):
        for file in ["hyprland.desktop", "sway.desktop"]:
            system(f"cp {file} /usr/share/wayland-sessions")

class Nixos(Initializer):
    def __init__(self, host):
        self.host = host
        super().__init__("nixos-flake.nix", "/etc/nixos/flake.nix", "nixos-rebuild")

    def string_pairs(self):
        return [("host", self.host)]

def getInitializer(args):
    match args.type:
        case "home-manager":
            return HomeManager(args.home, args.username)
        case "nixos":
            return Nixos(args.hostname)
        case _:
            raise NotImplementedError("Error, no such type")

if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument("--username", default=environ["USER"])
    parser.add_argument("--home", default=environ["HOME"])
    parser.add_argument("--hostname", default=check_output(["hostname"]).decode())
    parser.add_argument("--type", default="home-manager", choices=["home-manager", "nixos"])
    parser.add_argument("modes", nargs="+", choices=["init", "switch"])
    args = parser.parse_args()
    
    initializer = getInitializer(args)
    
    for mode in args.modes:
        initializer.execute(mode)
