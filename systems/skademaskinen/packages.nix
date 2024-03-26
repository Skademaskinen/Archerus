{pkgs, ...}:{
    environment.systemPackages = with pkgs; [
        lynx
        sqlite-interactive
    ];
    system.autoUpgrade = {
        enable = true;
        flags = [
            "--update-input"
            "nixpkgs"
            "-I"
            "nixos-config=/etc/nixos"
        ];
    };
}
