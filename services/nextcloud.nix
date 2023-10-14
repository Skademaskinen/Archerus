{ config, lib, pkgs, modulesPath, ... }: {
  services.nextcloud = {
    enable = true;
    home = "/mnt/raid/nextcloud";
    hostName = "skademaskinen.win";
    https = false;
    config = {
      adminpassFile = "/mnt/raid/nextcloud/adminpassFile";
    };
    extraOptions = {
      overwritewebroot = "";
      port = 11034;
      #overwritehost = "skademaskinen.win:11034";
      #overwriteprotocol = "https";
      "overwrite.cli.url" = "https://skademaskinen.win:11034";
      loglevel = 0;
    };
    nginx.recommendedHttpHeaders = true;
  };

}
