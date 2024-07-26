{config, pkgs, lib, ...}: let
    cfg = config.skademaskinen.minecraft;
    prefix = "${config.skademaskinen.storage}/minecraft";

    paper = pkgs.fetchurl {
        url = "https://api.papermc.io/v2/projects/paper/versions/1.21/builds/109/downloads/paper-1.21-109.jar";
        sha256 = "sha256-dsYGExSUEl8GTcLtQBuUbUoS4IvwzNvzLtqgi2Yzwwo=";
    };
    
    paper-wrapped = server: pkgs.stdenv.mkDerivation {
        name = "paper-wrapped-${server.name}";
        src = ./.;
        installPhase = ''
            mkdir -p $out/{bin,share}
            cat > $out/share/eula.txt << EOF
                eula=true
EOF
            ${(import ./builders/server.properties.nix { inherit lib; }) server}

            ${(import ./builders/paper-global.yml.nix { inherit lib config; }) server.paper-global}

            ${(import ./builders/paper-world-defaults.yml.nix { inherit lib; }) server.paper-world}

            ${(import ./builders/spigot.yml.nix { inherit lib; }) server.spigot}

            ${(import ./builders/bukkit.yml.nix { inherit lib; }) server.bukkit}

            cat > $out/bin/paper-wrapped << EOF
                mkdir -p ${prefix}/${server.name}/config
                cd ${prefix}/${server.name}
                ln -s $out/share/eula.txt ${prefix}/${server.name}/eula.txt
                cp $out/share/paper-global.yml ${prefix}/${server.name}/config
                cp $out/share/paper-world-defaults.yml ${prefix}/${server.name}/config
                cp $out/share/server.properties ${prefix}/${server.name}
                cp $out/share/bukkit.yml ${prefix}/${server.name}
                cp $out/share/spigot.yml ${prefix}/${server.name}
                chmod +rw ${prefix}/${server.name}/{bukkit.yml,spigot.yml,server.properties,config/paper-world-defaults.yml,config/paper-global.yml}

                ${pkgs.jdk21}/bin/java -jar ${paper}
EOF
            chmod +x $out/bin/paper-wrapped
        '';
    };
in paper-wrapped
