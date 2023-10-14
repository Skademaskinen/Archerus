{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    vim 
    openvpn
    mdadm
    mariadb_1011
    htop
    zsh
    zsh-syntax-highlighting
    zsh-autosuggestions
    nginx
    xrdp
    konsole
    nix-index
    ghc
    ihaskell
    mesa.drivers
    i3
    xorg.xinit.out
    feh
    picom
    nextcloud27
  ];
  hardware.opengl.enable = true;

  nixpkgs.config.allowUnfree = true;
}