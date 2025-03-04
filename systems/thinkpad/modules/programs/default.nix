{pkgs, ...}:

{
    programs.direnv = {
        enable = true;
        enableZshIntegration = true;
    };

    programs.firefox.enable = true;

    xdg.portal.config.common.default = "*";

    virtualisation.docker.enable = true;
    users.groups.docker.members = [
        "mast3r"
    ];
    programs.java = {
        enable = true;
        package = pkgs.jdk23;
    };

    services.tailscale = {
        enable = true;
    };
}
