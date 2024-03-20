{pkgs, ...}: {
    environment.systemPackages = with pkgs; [
        discord
        vscode
        yakuake
    ];
    programs.firefox.enable = true;
}
