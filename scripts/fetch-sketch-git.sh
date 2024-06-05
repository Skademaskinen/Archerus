#!bash

nix-shell -p nix-prefetch-git --run 'nix-prefetch-git https://github.com/Taoshix/SketchBot.git'

echo "---------------------------------------------------------------------------------------------------------------------"
echo ""
echo "hej nicolai, skriv 'rev' ind i 'rev' variablen og 'sha256' ind i 'sha256', i packages/sketch-bot/default.nix og kør: "
echo "cd /skademaskinen/Server-Config"
echo "git pull"
echo "sudo nixos-rebuild switch"
echo ""
echo "efter du har pushet ændringerne i packages/sketch-bot/default.nix til git :)"
