inputs: 

{ pkgs, lib, ... }:

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
        initContent = lib.mkAfter ''
            export "PROMPT=($USER@$HOST) $PROMPT"
        '';
        shellAliases = {
            "_g" = "_git";
            "g" = "git";
        };

    };
}
