{pkgs, lib, config, ...}: {
    options.skademaskinen.jupyter.port = lib.mkOption {
        type = lib.types.int;
        default = 30000;
    };
    config.services.jupyterhub = {
        enable = true;
        host = "localhost";
        port = config.skademaskinen.jupyter.port;
        extraConfig = ''
            c.NotebookApp.allow_origin = '*'
            c.NotebookApp.port = ${builtins.toString config.skademaskinen.jupyter.port}
            c.NotebookApp.allow_remote_access = True
            c.NotebookApp.trust_xheaders = True
            c.JupyterHub.base_url = '/jupyter'
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
