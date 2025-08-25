{ lib, nixpkgs, system, ... }:

let
    pkgs = lib.load nixpkgs;
    # --- cluster constants ---
    k3sPort = 6443;
    serverIP = "10.1.1.2";
    serverURL = "https://${serverIP}:${toString k3sPort}";
    clusterToken = "k3s-DEV-please-change-me";
    socketPort = 12345;

    nodeNames = [ "node-1" ];#"node-2" "node-3" ];
    nodeIPs   = [ "10.1.1.11" ];#"10.1.1.12" "10.1.1.13" ];
    nodeMACs  = [ "52:54:00:aa:00:11" ];#"52:54:00:aa:00:12" "52:54:00:aa:00:13" ];
    masterMAC = "52:54:00:aa:00:01";

    # --- Deployment yaml ---
    prerequisites = builtins.fetchurl {
        url = "https://skade.dev/api/p10/k8s/prerequisites.yml";
        sha256 = "sha256:1i9c04cq6wglhr6ngpsqmcc2jwv4lpb47sqfws69i9ssg47pb8yw";
    };
    autoscaler = builtins.fetchurl {
        url = "https://skade.dev/api/p10/k8s/autoscaler.yml";
        sha256 = "sha256:05pap73mp545689srzpa7zllr1bgi8ifmajkvms70fmvfblzy8mr";
    };
    migrate = builtins.fetchurl {
        url = "https://skade.dev/api/p10/k8s/migrate.sh";
        sha256 = "sha256:1b4062qc5c6j17808wxgp8a56ia55qxgx36ffj8fq7la4i9x3fzr";
    };

    mkLan = mac: ip: {
        networking.useNetworkd = true;
        systemd.network.enable = true;

        systemd.network.links."10-lan0" = {
            matchConfig.MACAddress = mac;
            linkConfig.Name = "lan0";
        };
        systemd.network.networks."20-lan0" = {
            matchConfig.Name = "lan0";
            networkConfig.Address = "${ip}/24";
        };

        systemd.network.networks."10-wan" = {
            matchConfig.Name = "en* eth*";
            matchConfig.Type = "ether";
            linkConfig.RequiredForOnline = true;
            networkConfig.DHCP = "yes";
        };
    };

    shared = { pkgs, ... }: {
        system.stateVersion = "25.05";
        services.getty.autologinUser = "root";
        users.users.root.password = "1234";
        networking.firewall.enable = false;
        environment.systemPackages = with pkgs; [ kubectl ];
        virtualisation.vmVariant.virtualisation.cores = 2;
        virtualisation.vmVariant.virtualisation.diskSize = 2024;
        virtualisation.vmVariant.virtualisation.memorySize = 8196;
    };

    scripts = {
        prerequisites = "${pkgs.kubectl}/bin/kubectl apply -f ${prerequisites}";
        migrate = "${pkgs.bash}/bin/bash ${migrate}";
        autoscaler = "${pkgs.kubectl}/bin/kubectl apply -f ${autoscaler}";
    };

    master = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
            shared
            (mkLan masterMAC serverIP)
            {
                networking.hostName = "master";
                services.k3s = {
                    enable = true;
                    role = "server";
                    token = clusterToken;
                    clusterInit = true;
                    extraFlags = [
                        "--https-listen-port=${toString k3sPort}"
                        "--advertise-address=${serverIP}"
                    ];
                };
                environment.variables.KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
                virtualisation.vmVariant.virtualisation = {
                    graphics = false;
                    qemu.options = [
                        "-netdev" "socket,id=lan0,listen=127.0.0.1:${toString socketPort}"
                        "-device" "virtio-net-pci,netdev=lan0,mac=${masterMAC}"
                    ];
                };

                environment.systemPackages = map (n: pkgs.writeScriptBin n ''
                    #!${pkgs.bash}/bin/bash
                    ${scripts.${n}}
                '') (builtins.attrNames scripts) ++ [ pkgs.postgresql ];

            }
        ];
    };

    nodes = pkgs.lib.imap0
      (i: name:
        nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
                shared
                (mkLan (builtins.elemAt nodeMACs i) (builtins.elemAt nodeIPs i))
                {
                    networking.hostName = name;
                    services.k3s = {
                        enable = true;
                        role = "agent";
                        serverAddr = serverURL;
                        token = clusterToken;
                    };
                    virtualisation.vmVariant.virtualisation = {
                        graphics = false;
                        qemu.options = [
                            "-netdev" "socket,id=lan0,connect=127.0.0.1:${toString socketPort}"
                            "-device" "virtio-net-pci,netdev=lan0,mac=${builtins.elemAt nodeMACs i}"
                        ];
                    };
                }
            ];
        })
      nodeNames;

    systems = [ master ] ++ nodes;


    # --- wrap each run script ---
    wrap = system:
      let
        runScript = "${system.config.system.build.vm}/bin/run-${system.config.networking.hostName}-vm";
      in
      "${pkgs.writeShellScriptBin "run-wrapped" ''
        set -euo pipefail
        # Clean qcow2 disks first to ensure reproducibility
        rm -f *.qcow2
        exec ${runScript} "$@"
      ''}/bin/run-wrapped";

in
lib.mkParallelScripts "testCluster" (map wrap systems)

