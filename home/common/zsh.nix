{pkgs, config, ...}:

{
    programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        shellAliases = {
            edit = "${pkgs.home-manager}/bin/home-manager edit";
            switch = "${pkgs.home-manager}/bin/home-manager switch";
            ls = "ls --color";
            vim = "nvim";
            nix-repl = ''${pkgs.nix}/bin/nix repl --expr "import <nixpkgs> {}"'';
        };
        history = {
            size = 1000;
            path = "${config.xdg.dataHome}/zsh/history";
        };
    };
    programs.direnv.enable = true;
}
