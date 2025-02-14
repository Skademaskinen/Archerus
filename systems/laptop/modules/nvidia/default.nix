{config, ...}:

{
    hardware.graphics = {
        enable = true;
    };

    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true;
        powerManagement.finegrained = false;
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.vulkan_beta;
        prime.intelBusId = "PCI:0:2:0";
        prime.nvidiaBusId = "PCI:1:0:0";
    };


}
