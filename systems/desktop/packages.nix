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
    ];
    programs.firefox.enable = true;

    programs.neovim = {
        enable = true;
    };
    programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        shellAliases = {
            edit = "${pkgs.home-manager}/bin/home-manager edit";
            switch = "${pkgs.home-manager}/bin/home-manager switch";
        };
        history = {
            size = 1000;
            path = "${config.xdg.dataHome}/zsh/history";
        };
    };


    programs.direnv.enable = true;

    programs.git = {
        enable = true;
        userEmail = "mast3r@skade.dev";
        userName = "Thomas Jensen";
    };
}