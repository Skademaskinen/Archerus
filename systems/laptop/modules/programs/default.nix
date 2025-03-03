{pkgs, ...}:

{
    programs.direnv = {
        enable = true;
        enableZshIntegration = true;
    };

    programs.firefox.enable = true;

    programs.steam.enable = true;
    programs.gamescope.enable = true;
    programs.steam.gamescopeSession.enable = true;

    programs.obs-studio.enable = true;
    xdg.portal.enable = true;
    xdg.portal.config.common.default = "*";

    virtualisation.docker.enable = true;
    users.groups.docker.members = [
        "mast3r"
    ];
    programs.java = {
        enable = true;
        package = pkgs.jdk23;
    };

    programs.coolercontrol = {
        enable = true;
        nvidiaSupport = true;
    };

    services.tailscale = {
        enable = true;
    };
}
