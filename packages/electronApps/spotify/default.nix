{ pkgs, lib, ... }:

lib.mkElectronApp {
    iconOperations = [
        lib.images.cropToContent
    ];
    iconSha256 = "sha256:1wpr5vpw4kdm7fad99mq1ijs2dcy3pzz7rq9b3zjxyrx1wq9ri54";
    appName = "Spotify";
    url = "https://open.spotify.com";
    description = "Spotify in an electron app";
}
