{lib, ...}: let
    tools = import ../tools.nix { lib = lib; };
in opts: with opts; with tools; ''
    cat > $out/share/paper-world-defaults.yml << EOF
    EOF
''