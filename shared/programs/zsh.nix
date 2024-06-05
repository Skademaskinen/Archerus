{pkgs, ...}: {
    programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestions.enable = true;
        syntaxHighlighting.enable = true;

        shellAliases = {
            switch = "sudo ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch";
            boot = "sudo ${pkgs.nixos-rebuild}/bin/nixos-rebuild boot";
            build-vm = "${pkgs.nixos-rebuild}/bin/nixos-rebuild build-vm";
            edit = "vim /skademaskinen/Server-Config";
            cat = "${pkgs.bat}/bin/bat -pp";
        };
        promptInit = "PROMPT=\"%F{#55AAFF}[%F{#FF5500}%n%f@%F{#FF5500}%m%F{#55AAFF}] %F{#888888}%~ %F{#55AAFF}> %f\"";
    };
}
