# this module is needed for compatibility, as the server is already running systemd-boot
inputs:

{
    boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
    };
}
