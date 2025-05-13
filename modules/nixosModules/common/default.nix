inputs:

{ pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        vim
    ];

}
