{config, pkgs, lib, ...}: let
    cfg = config.skademaskinen.minecraft;
    prefix = "${config.skademaskinen.storage}/minecraft";

    fabric = pkgs.fetchurl {
        url = "https://meta.fabricmc.net/v2/versions/loader/1.21/0.15.11/1.0.1/server/jar";
        sha256 = "sha256-ZRSgXk5CChjXYnNTTudV1fV1ijc/Nh4Jd9NDQKZVkYU=";
    };
    fabric-wrapped = server: pkgs.stdenv.mkDerivation {
        name = "paper-wrapped-${server.name}";
        src = ./.;
        installPhase = ''
            mkdir -p $out/{bin,share/mods}
            echo "eula=true" > $out/share/eula.txt


            cp ${(import ./builders/server.properties.nix { inherit pkgs lib; }) server} $out/share/server.properties

            cp ${(import ./builders/spigot.yml.nix { inherit pkgs lib; }) server.spigot} $out/share/spigot.yml

            cp ${(import ./builders/bukkit.yml.nix { inherit pkgs lib; }) server.bukkit} $out/share/bukkit.yml

            cp ${pkgs.fetchurl {
                url = "https://github.com/OKTW-Network/FabricProxy-Lite/releases/download/v2.9.0/FabricProxy-Lite-2.9.0.jar";
                sha256 = "sha256-wIQA86Uh6gIQgmr8uAJpfWY2QUIBlMrkFu0PhvQPoac=";
            }} $out/share/mods/FabricProxy-Lite.jar

            cat > $out/bin/fabric-wrapped << EOF
                mkdir -p ${prefix}/${server.name}/{plugins,mods,config}
                cd ${prefix}/${server.name}
                ln -s $out/share/eula.txt ${prefix}/${server.name}/eula.txt
                cp $out/share/server.properties ${prefix}/${server.name}
                cp $out/share/bukkit.yml ${prefix}/${server.name}
                cp $out/share/spigot.yml ${prefix}/${server.name}
                rm -f ${prefix}/${server.name}/{plugins,mods}/*.jar

                ${builtins.concatStringsSep "\n" (builtins.attrValues (builtins.mapAttrs (name: path: "ln -s ${path} ${prefix}/${server.name}/plugins/${name}") server.plugins))}
                ${builtins.concatStringsSep "\n" (builtins.attrValues (builtins.mapAttrs (name: path: "ln -s ${path} ${prefix}/${server.name}/mods/${name}") server.mods))}
                ln -s $out/share/mods/FabricProxy-Lite.jar ${prefix}/${server.name}/mods/FabricProxy-Lite.jar

                echo "secret = \"${cfg.secret}\"" > ${prefix}/${server.name}/config/FabricProxy-Lite.toml

                chmod +rw ${prefix}/${server.name}/{bukkit.yml,spigot.yml,server.properties,config/paper-world-defaults.yml,config/paper-global.yml}

                ${pkgs.jdk21}/bin/java -jar ${fabric}
EOF
            chmod +x $out/bin/fabric-wrapped
        '';
    };
in fabric-wrapped
