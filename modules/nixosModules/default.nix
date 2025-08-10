{ lib, ... }:

lib.mkSubmodules [
    ./common
    ./desktop
    ./gaming
    ./server
    ./grub
    ./plymouth
    ./programming
    ./users
]
