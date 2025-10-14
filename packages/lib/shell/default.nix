# this file contains shell scripts and functions as sort of "macros"
{ self, pkgs, ... }:

rec {
    parallel = commands: let
        tmux = "${pkgs.tmux}/bin/tmux";
        keys = builtins.attrNames commands;
        values = map (key: pkgs.writeShellScript key commands.${key}) keys;
    in pkgs.writeShellScript "parallel-tmux" ''
        SESSION="parallel-$RANDOM"

        ${builtins.toString (pkgs.lib.imap0 (i: script: ''
            ${if i == 0 then ''
                ${tmux} new-session -d -s "$SESSION" "${script}"
            '' else ''
                ${tmux} split-window -h -t "$SESSION" "${script}"
            ''
            }
            ${tmux} select-pane -t "$SESSION:0.${builtins.toString i}" -T "${builtins.elemAt keys i}"
        '') values)}

        ${tmux} select-layout -t "$SESSION" even-horizontal
        ${tmux} set-option -t "$SESSION" remain-on-exit off
        ${tmux} set-option -g pane-border-status top

        ${tmux} attach -t "$SESSION"
    '';

    copy = host: path: target: pkgs.writeShellScript "copy" ''
        #!/usr/bin/env bash
        ${pkgs.openssh}/bin/scp ${path} ${host}:${target}
    '';

    remote = host: script: pkgs.writeShellScript "remote" ''
        #!/usr/bin/env bash
        target=$(mktemp)
        ${copy host (pkgs.writeText "script.sh" script) "$1"} $target
        ${pkgs.openssh}/bin/ssh ${host} chmod 664 $target
        ${pkgs.openssh}/bin/ssh ${host} chmod +x $target
        ${pkgs.openssh}/bin/ssh -tt ${host} $target
    '';

    waitForLock = lockfile: ''
        while ! test -f ${lockfile}; do
            sleep 1
        done
    '';

    waitForUnlock = lockfile: ''
        while test -f ${lockfile}; do
            sleep 1
        done
    '';

    whileLocked = lockfile: script: ''
        ${waitForLock lockfile}
        while test -f ${lockfile}; do
            ${pkgs.writeShellScript "script.sh" script}
            sleep 1
        done
    '';

    lockGuard = lockfile: script: ''
        ${lock lockfile}
        ${pkgs.writeShellScript "script.sh" script}
        ${unlock lockfile}
    '';

    lock = lockfile: ''
        ${waitForUnlock lockfile}
        touch ${lockfile}
    '';

    unlock = lockfile: ''
        rm -f ${lockfile}
    '';

    parallel-test = pkgs.writeScriptBin "parallel-test" ''
        #!/usr/bin/env bash
        ${parallel {
            a = "sleep 5";
            b = "sleep 10";
            c = "sleep 15";
        }};
    '';

    skademaskinen = let
        lockfile = "/tmp/skademaskinen-scripting.lock";
        cfg = self.nixosConfigurations.Skademaskinen.config;
    in {
        pull-rebuild = pkgs.writeScriptBin "pull-rebuild" ''
            #!/usr/bin/env bash
            ${parallel {
                rebuild = lockGuard lockfile (remote cfg.skade.baseDomain ''
                    cd /etc/nixos
                    git pull
                    sudo nixos-rebuild switch --verbose
                '');
                disk-usage = whileLocked lockfile (remote cfg.skade.baseDomain ''
                    clear
                    df / -h
                    df ${cfg.skade.projectsRoot} -h
                '');
            }}
        '';

        optimize = pkgs.writeScriptBin "optimize" ''
            #!/usr/bin/env bash
            ${parallel {
                disk-usage = whileLocked lockfile (remote cfg.skade.baseDomain ''
                    clear
                    df / -h
                    df ${cfg.skade.projectsRoot} -h
                '');
                optimize = lockGuard lockfile (remote cfg.skade.baseDomain ''
                    sudo sh -c '
                        echo "Running garbage collect"
                        nix-store --gc
                        echo "Running optimize"
                        nix-store --optimize
                    '
                '');
            }}
        '';
    };
}
