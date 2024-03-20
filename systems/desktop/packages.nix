{pkgs, ...}:{
    environment.systemPackages = with pkgs; [
        bottles
        discord
        spotify
        vscode
        firefox
        yakuake
    ];
}
