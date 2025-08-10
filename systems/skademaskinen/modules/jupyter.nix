{pkgs, lib, config, ...}: {
    options.skademaskinen.jupyter.port = lib.mkOption {
        type = lib.types.int;
        default = 30000;
    };

    config.users.users.jupyter = {
        isSystemUser = true;
        group = "jupyter";
    };
    config.users.groups.jupyter = {};

    config.services.jupyterhub = {
        enable = false; # not really being used anymore
        port = config.skademaskinen.jupyter.port;
        extraConfig = ''
            c.Spawner.notebook_dir = '${config.skademaskinen.storage}/jupyter'
        '';
        kernels.haskell = let
            env = pkgs.ghc.withPackages (hs: with hs; [
                ihaskell
            ]);
        in {
            displayName = "haskell environment";
            argv = [
                "${env}/bin/ihaskell"
                "kernel"
                "{connection_file}"
            ];
            language = "haskell";
            
        };

        kernels.bash = let
            env = pkgs.python311.withPackages (py: with py; [bash_kernel]);
        in {
            displayName = "bash env";
            argv = [
                "${env.interpreter}"
                "-m"
                "bash_kernel"
                "-f"
                "{connection_file}"
            ];
            language = "bash";
        };

    };
}
