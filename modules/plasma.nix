{
    services = {
        xserver = {
            enable = true;
            displayManager = {
                sddm = {
                    enable = true;
                    wayland = {
                        enable = true;
                    };
                };
                defaultSession = "plasma";
            };
            desktopManager = {
                plasma6 = {
                    enable = true;
                };
            };
        };
        pipewire = {
            enable = true;
            alsa.enable = true;
            pulse.enable = true;
        };
    };
}
