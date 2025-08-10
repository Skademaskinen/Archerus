{pkgs, config, ...}: {
    services.matrix-conduit = {
        enable = true;
        settings.global.port = config.skademaskinen.matrix.port;
        settings.global.allow_registration = false;
    };
}
