{ lib, nixpkgs, ... }:

let
    pkgs = lib.load nixpkgs;
in

name: commands:
pkgs.writeScriptBin name ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    session="${name}"
    ${pkgs.tmux}/bin/tmux new-session -d -s "$session" -n "cmd0"

    i=0
    for cmd in ${pkgs.lib.concatStringsSep " " (map (c: pkgs.lib.escapeShellArg c) commands)}; do
        if [ $i -eq 0 ]; then
            ${pkgs.tmux}/bin/tmux send-keys -t "$session":0 "$cmd" C-m
        else
            ${pkgs.tmux}/bin/tmux split-window -t "$session":0 -h
            ${pkgs.tmux}/bin/tmux select-layout -t "$session":0 tiled
            ${pkgs.tmux}/bin/tmux send-keys -t "$session":0.$i "$cmd" C-m
        fi
        i=$((i+1))
    done

    ${pkgs.tmux}/bin/tmux attach -t "$session"
''

