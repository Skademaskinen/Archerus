{config, ...}: {
    services.xserver.videoDrivers = [
        "intel"
        "nvidia"
    ];

    hardware.nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.beta;
        modesetting.enable = true;
        nvidiaSettings = true;
        powerManagement.enable = true;
    };
}