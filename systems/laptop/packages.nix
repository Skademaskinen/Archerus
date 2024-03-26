{pkgs, ...}: {
    environment.systemPackages = with pkgs; [
        discord
        vscode
        yakuake
        direnv
        kmail
    ];

    programs.firefox.enable = true;
}
