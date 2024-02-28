{pkgs, ...}: {
    hardware.opengl.enable = true;

    nixpkgs.config.allowUnfree = true;

    programs.java.enable = true;

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

}
