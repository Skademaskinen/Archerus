{
    security.sudo.wheelNeedsPassword = false;

    nix.settings.allowed-users = ["root" "@wheel"];
    nix.settings.trusted-users = ["root" "@wheel"];
}