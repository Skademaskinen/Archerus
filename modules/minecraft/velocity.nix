{config, pkgs, ...}: let 
    cfg = config.skademaskinen.minecraft;
    prefix = "${config.skademaskinen.storage}/minecraft";
    
    velocity = pkgs.fetchurl {
        url = "https://api.papermc.io/v2/projects/velocity/versions/3.3.0-SNAPSHOT/builds/412/downloads/velocity-3.3.0-SNAPSHOT-412.jar";
        sha256 = "sha256-KOBsdASYlUxf2np87DK3KnSHFM5hMjPqdYD2Ati8yIQ=";
    };

    velocity-wrapped = pkgs.stdenv.mkDerivation {
        name = "velocity-wrapped";
        src = ./.;
        installPhase = ''
            mkdir -p $out/{bin,share}
            cat > $out/share/velocity.toml << EOF
                config-version = "2.7"
                bind = "0.0.0.0:${builtins.toString cfg.port-range-start}"
                motd = "${cfg.motd}"
                show-max-players = 500
                online-mode = true
                force-key-authentication = false
                prevent-client-proxy-connections = false
                player-info-forwarding-mode = "modern"
                forwarding-secret-file = "${pkgs.writeText "secret" cfg.secret}"
                annouce-forge = false
                kick-existing-players = false
                ping-passthrough = "disabled"
                enable-player-address-logging = true
                [servers]
EOF

            cat > $out/share/populate-servers.py << EOF
names = "${builtins.toString cfg.servers}".split(" ")
start = ${builtins.toString cfg.port-range-start}
ports = [p for p in range(start, start+len(names))]

with open("$out/share/velocity.toml", "a") as file:
    for name, port in zip(names, ports):
        file.write(f'{name} = "127.0.0.1:{port}"\n')

    file.write(f'try = ["${cfg.fallback}"]\n')

    file.write("[forced-hosts]\n")
    for name, port in zip(names, ports):
        file.write(f'"{name}.${config.skademaskinen.domain}" = ["{name}"]\n')
EOF

            ${pkgs.python311}/bin/python $out/share/populate-servers.py

            cat > $out/bin/velocity-wrapped << EOF
                mkdir -p ${prefix}/velocity
                cd ${prefix}/velocity
                rm -f ${prefix}/velocity/velocity.toml
                cp $out/share/velocity.toml ${prefix}/velocity/velocity.toml
                ${pkgs.jdk21}/bin/java -jar ${velocity}
EOF

            chmod +x $out/bin/velocity-wrapped
        '';
    };
in velocity-wrapped