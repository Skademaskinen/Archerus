{ lib, ... }:

lib.mkSubmodules [
    ./common
    ./desktop
    ./gaming
    ./server
    ./grub
    ./systemd-boot
    ./plymouth
    ./programming
    ./users
]
