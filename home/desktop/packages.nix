{pkgs, config, ...}:

{
    home.packages = with pkgs; [
        vesktop
        spotify
        wowup-cf
        direnv
        vscode
        gimp
        mesa
        okular
        neovide
        signal-desktop
        waypipe
    ];
    programs.firefox.enable = true;

    programs.neovim = {
        enable = true;
    };
    programs.direnv.enable = true;

    programs.git = {
        enable = true;
        userEmail = "mast3r@skade.dev";
        userName = "Thomas Jensen";
    };
}
