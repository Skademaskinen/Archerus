inputs: 

{ pkgs, ... }:

{
    programs.zsh = {
        enable = true;
        autosuggestion.enable = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;
        prezto = {
            enable = true;
            prompt.theme = "minimal";
        };
        shellAliases = {
            "_g" = "_git";
            "g" = "git";
        };
    };
}
