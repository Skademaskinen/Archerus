{
    programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestions.enable = true;
        syntaxHighlighting.enable = true;

        shellAliases = {
            update = "sudo nixos-rebuild switch";
        };
        promptInit = "PROMPT=\"%F{#55AAFF}[%F{#FF5500}%n%f@%F{#FF5500}%m%F{#55AAFF}] %F{#888888}%~ %F{#55AAFF}> %f\"";
    };
}