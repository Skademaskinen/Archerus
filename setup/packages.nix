{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    vim 
    (import ../packages/backend.nix {})
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
    zulu
    sqlite-interactive
    (python311.withPackages(ps: with ps; [
      ipython
      requests
      sqlite
    ]))
  ];
  hardware.opengl.enable = true;

  nixpkgs.config.allowUnfree = true;

  programs.java.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  system.autoUpgrade = {
    enable = true;
    flags = [
      "--update-input"
      "nixpkgs"
      "-I"
      "nixos-config=/etc/nixos"
    ];
    dates = "02:00";
    allowReboot = true;
  };
}
