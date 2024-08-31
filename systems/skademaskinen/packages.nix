{pkgs, config, nix-velocity, homepage, ...}:{
    environment.systemPackages = with pkgs; [
        lynx
        sqlite-interactive
        (nix-velocity.mc-cmd config)
        homepage.packages.x86_64-linux.default
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
