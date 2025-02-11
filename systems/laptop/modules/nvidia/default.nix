{config, ...}:

{
    hardware.graphics = {
        enable = true;
    };

    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = false;
        powerManagement.finegrained = false;
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        prime.intelBusId = "PCI:0:2:0";
        prime.nvidiaBusId = "PCI:1:0:0";
        prime.sync.enable = true;
    };


}
