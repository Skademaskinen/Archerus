{pkgs, lib, config, ...}: {
    options.skademaskinen.jupyter.port = lib.mkOption {
        type = lib.types.int;
        default = 30000;
    };

    config.users.users.jupyter = {
        isSystemUser = true;
        group = "jupyter";
    };

    config.services.jupyterhub = {
        enable = true;
        port = config.skademaskinen.jupyter.port;
        extraConfig = ''
            c.Spawner.notebook_dir = ${config.skademaskinen.storage}/jupyter
        '';

    };
}
