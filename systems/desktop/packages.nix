{pkgs, ...}:{
    environment.systemPackages = with pkgs; [
        bottles
        discord
        spotify
    ];
}
