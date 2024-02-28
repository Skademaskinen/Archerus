{ pkgs, config, ... }: {
  services.xserver = {
    layout = "dk";
    xkbVariant = "winkeys";
    enable = true;
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
    displayManager.defaultSession = "sway";
    videoDrivers = [ "intel" "nouveau" ];
  };
  programs.sway = {
    enable = true;
    extraOptions = [
      "--unsupported-gpu"
    ];
  };
  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      modesetting.enable = true;
      nvidiaSettings = true;
      powerManagement.enable = true;
    };
    bluetooth = {
      enable = true;
    };
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  #xdg.portal.wlr.enable = true;
}
