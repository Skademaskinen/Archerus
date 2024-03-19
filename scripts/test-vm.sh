rm *.qcow2
rm result -rf

if ! [[ "$1" == "" ]]; then
    nixos-rebuild build-vm --flake .#$1
    ./result/bin/run-*-vm
else
    nixos-rebuild build-vm --flake .#Skademaskinen
    ./result/bin/run-Skademaskinen-vm &
    nixos-rebuild build-vm --flake .#laptop
    ./result/bin/run-laptop-vm &
    nixos-rebuild build-vm --flake .#laptop-proprietary
    ./result/bin/run-laptop-vm &
    nixos-rebuild build-vm --flake .#desktop
    ./result/bin/run-desktop-vm
fi