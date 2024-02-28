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
    nix-index
    ghc
    feh
    nextcloud27
    zulu
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
