{ lib, ... }:

lib.mkSubmodules [
    ./base.nix
    ./projects/homepage.nix
    ./projects/putricide.nix
    ./projects/folkevognen.nix
    ./projects/dummyProject.nix
    ./projects/taoshi-web.nix
    ./projects/sketch-bot.nix

    # external projects
    ./projects/palworld.nix
    ./projects/mysql.nix
    ./projects/nextcloud.nix
    ./projects/minecraft.nix
    ./projects/matrix.nix
    ./projects/prometheus.nix
]
