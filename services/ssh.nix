{
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
    settings.X11Forwarding = true;
  };
}