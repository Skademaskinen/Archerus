{ config, lib, pkgs, modulesPath, ... }: {
  users.users.taoshi = {
    isNormalUser = true;
    description = "taosh";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      openjdk
      dotnet-sdk_7
      nodejs
      screen
      neofetch
    ];
  };
}