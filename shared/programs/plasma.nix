{pkgs, ...}: {
    imports = [./pipewire.nix];
    services.xserver.desktopManager.plasma6.enable = true;
    environment.systemPackages = with pkgs.kdePackages; [
        plasma-pa
    ];
}
