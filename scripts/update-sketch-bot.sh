#!bash

cd packages/sketch-bot
script=$(nix-build -A passthru.fetch-deps)

$script deps.nix

cd ../..
