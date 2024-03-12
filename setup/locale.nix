{pkgs, ...}: {
    time.timeZone = "Europe/Copenhagen";

    i18n.defaultLocale = "en_DK.UTF-8";

    i18n.extraLocaleSettings = {
        LC_ADDRESS = "da_DK.UTF-8";
        LC_IDENTIFICATION = "da_DK.UTF-8";
        LC_MEASUREMENT = "da_DK.UTF-8";
        LC_MONETARY = "da_DK.UTF-8";
        LC_NAME = "da_DK.UTF-8";
        LC_NUMERIC = "da_DK.UTF-8";
        LC_PAPER = "da_DK.UTF-8";
        LC_TELEPHONE = "da_DK.UTF-8";
        LC_TIME = "da_DK.UTF-8";
    };
    
    users.motd = builtins.readFile ../files/motd.txt;

    services.xserver = {
        layout = "dk";
        xkbVariant = "winkeys";
    };
    
    console.keyMap = "dk-latin1";


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
