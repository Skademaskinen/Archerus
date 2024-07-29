{pkgs, config, nix-velocity, ...}:{
    environment.systemPackages = with pkgs; [
        lynx
        sqlite-interactive
        (nix-velocity.mc-cmd config)
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

    services.cachix-agent.enable = true;
}
