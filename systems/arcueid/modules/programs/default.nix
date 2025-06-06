{pkgs, ...}:

{
    imports = [
        ./gaming.nix
    ];
    programs.direnv = {
        enable = true;
        enableZshIntegration = true;
    };

    programs.firefox.enable = true;

    xdg.portal.config.common.default = "*";
    xdg.portal.wlr.enable = true;

    programs.java = {
        enable = true;
        package = pkgs.jdk23;
    };

    virtualisation.docker.enable = true;
    users.groups.docker.members = [
        "mast3r"
    ];
}
