{ config, lib, pkgs, modulesPath, ... }: {
    users.users.mast3r = {
    isNormalUser = true;
    description = "mast3r";
    extraGroups = [ "networkmanager" "wheel" "wireshark" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      #neofetch
      openjdk
      python311
      bat
      sqlite
      screen
      maven
      ghc
      unzip
      pfetch
      tmux
      nmap
      firefox
      wget
      lynx
      libsForQt5.plasma-workspace
      termshark
    ];
  };
  
}
