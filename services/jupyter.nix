{pkgs, ...}: {
    services.jupyterhub = let
        jupyterPkgs = with pkgs; [
            haskellPackages.ihaskell
            ghc
        ];

    in {
        enable = true;
        host = "0.0.0.0";
        port = 30000;
        extraConfig = ''
            c.JupyterHub.base_url = '/jupyter'
            c.JupyterHub.hub_ip = '127.0.0.1'
            c.JupyterHub.ip = '0.0.0.0'
            c.JupyterHub.port = 30000
            c.Spawner.notebook_dir = "/mnt/raid/jupyter"
            c.Session.debug = True
            c.JupyterHub.hub_port = 30001
        '';
        kernels = {
            python311 = let
                env = (pkgs.python311.withPackages (pythonPackages: with pythonPackages; [
                    ipykernel
                    jupyterhub
                ]));

            in {
                displayName = "Custom Python3.11 Environment";
                argv = [
                    "${env.interpreter}"
                    "-m"
                    "ipykernel_launcher"
                    "-f"
                    "{connection_file}"
                ];
                language = "python";
                logo32 = "${env}/${env.sitePackages}/ipykernel/resources/logo-32x32.png";
                logo64 = "${env}/${env.sitePackages}/ipykernel/resources/logo-64x64.png";
            };
            haskell = let
                env = (pkgs.ghc.withPackages (haskellPackages: with haskellPackages; [
                    ihaskell
                ]));
            in {
                displayName = "Custom Haskell Environment";
                argv = [
                    "${pkgs.haskellPackages.ihaskell}/bin/ihaskell" "kernel" "{connection_file}" "--ghclib" "${pkgs.ghc}/lib/ghc-9.4.8" "+RTS" "-M3g" "-N2" "-RTS"
                ];
                language = "haskell";
            };
        }; 
    };
}
