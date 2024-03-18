{pkgs, ...}:{
    environment.systemPackages = with pkgs; [

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