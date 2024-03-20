{pkgs, lib, config, ...}: {
    options.skademaskinen.jupyter.port = lib.mkOption {
        type = lib.types.int;
        default = 30000;
    };
    config.services.jupyterhub = {
        enable = true;
        host = "${config.skademaskinen.domain}";
        port = config.skademaskinen.jupyter.port;
        extraConfig = ''
            c.Spawner.notebook_dir = "${config.skademaskinen.storage}/jupyter"
            c.JupyterHub.hub_ip = '127.0.0.1'
            c.JupyterHub.hub_port = ${builtins.toString (config.skademaskinen.jupyter.port + 1000)}
            c.JupyterHub.ip = '0.0.0.0'
            c.JupyterHub.port = ${builtins.toString config.skademaskinen.jupyter.port}
        '';
        kernels.python311 = let
            env = (pkgs.python311.withPackages (py: with py; [
                ipykernel
                jupyterhub
            ]));
        in {
            displayName = "Custom python311 env";
            argv = [
                "${env.interpreter}"
                "-m" "ipykernel_launcher"
                "-f" "{connection_file}"
            ];
            language = "python";
            logo32 = "${env}/${env.sitePackages}/ipykernel/resources/logo-32x32.png";
            logo64 = "${env}/${env.sitePackages}/ipykernel/resources/logo-64x64.png";
        };
    };
}
