{ lib, nixpkgs, ...}:

let
    pkgs = lib.load nixpkgs;
in

{ ports, vhosts, format ? "png" }:

let
    dotFile = pkgs.writeText "architecture.dot" ''
        digraph architecture {
            rankdir=LR;
            node [shape=box];

            // Ports
            subgraph cluster_ports {
                label = "Open Ports";
                ${builtins.concatStringsSep "\n" (map (p: "\"Port ${toString p}\";") ports)}
            }

            // Virtual Hosts
            subgraph cluster_vhosts {
                label = "Virtual Hosts";
                ${builtins.concatStringsSep "\n" (map (domain: "\"${domain}\";") (builtins.attrNames vhosts))}
            }

            // Links: vhost -> port
            ${builtins.concatStringsSep "\n" (
                map (domain:
                    let
                        v = vhosts.${domain};
                    in
                        "\"${domain}\" -> \"Port ${toString v.port}\";"
                ) (builtins.attrNames vhosts)
            )}
        }
    '';
in
pkgs.runCommand "architecture-diagram.${format}" { buildInputs = [ pkgs.graphviz ]; } ''
    dot -T${format} ${dotFile} -o $out
''

