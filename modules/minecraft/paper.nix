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
            echo "eula=true" > $out/share/eula.txt


            cp ${(import ./builders/server.properties.nix { inherit pkgs lib; }) server} $out/share/server.properties

            cp ${(import ./builders/paper-global.yml.nix { inherit pkgs lib; }) server.paper-global} $out/share/paper-global.yml

            cp ${(import ./builders/paper-world-defaults.yml.nix { inherit pkgs lib; }) server.paper-world} $out/share/paper-world-defaults.yml

            cp ${(import ./builders/spigot.yml.nix { inherit pkgs lib; }) server.spigot} $out/share/spigot.yml

            cp ${(import ./builders/bukkit.yml.nix { inherit pkgs lib; }) server.bukkit} $out/share/bukkit.yml

            cat > $out/bin/paper-wrapped << EOF
                mkdir -p ${prefix}/${server.name}/{config,plugins}
                cd ${prefix}/${server.name}
                ln -s $out/share/eula.txt ${prefix}/${server.name}/eula.txt
                cp $out/share/paper-global.yml ${prefix}/${server.name}/config
                cp $out/share/paper-world-defaults.yml ${prefix}/${server.name}/config
                cp $out/share/server.properties ${prefix}/${server.name}
                cp $out/share/bukkit.yml ${prefix}/${server.name}
                cp $out/share/spigot.yml ${prefix}/${server.name}

                rm -f ${prefix}/${server.name}/plugins/*.jar

                ${builtins.concatStringsSep "\n" (builtins.attrValues (builtins.mapAttrs (name: path: "ln -s ${path} ${prefix}/${server.name}/plugins/${name}") server.plugins))}

                chmod +rw ${prefix}/${server.name}/{bukkit.yml,spigot.yml,server.properties,config/paper-world-defaults.yml,config/paper-global.yml}

                ${pkgs.jdk21}/bin/java -jar ${paper}
EOF
            chmod +x $out/bin/paper-wrapped
        '';
    };
in paper-wrapped
