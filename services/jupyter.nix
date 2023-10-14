{ config, lib, pkgs, modulesPath, ... }: {
  #services.jupyter.package = pkgs.ihaskell;
  services.jupyter.enable = true;
  services.jupyter.port = 30000;
  services.jupyter.ip = "localhost";
  services.jupyter.notebookDir = "/mnt/raid/notebook";
  services.jupyter.password = "skademaskinen-jupyter";
  users.users.jupyter.group = "jupyter";
  users.groups.jupyter = {};
  users.users.jupyter.packages = with pkgs; [
    jupyter
    python311
    python310
    ihaskell
    python311Packages.nbconvert
    python311Packages.pyppeteer
    python311Packages.bash_kernel
    #python311Packages.ipywidgets
    neofetch
    pandoc
    feh
    gcc
    pfetch
    ghc
    git
  ];
  services.jupyter.kernels = {
    python311 = let
      env = (pkgs.python311.withPackages (pythonPackages: with pythonPackages; [
        ipykernel
        numpy
        matplotlib
        tornado
      ]));
    in {
      displayName = "Custom Python3.11 environment";
      argv = [ "${env.interpreter}" "-m" "ipykernel_launcher" "-f" "{connection_file}" ];
      language = "python";
    };
    python310 = let
      env = (pkgs.python310.withPackages (pythonPackages: with pythonPackages; [
        ipykernel
        numpy
        matplotlib
        pytorch
      ]));
    in {
      displayName = "Custom Python3.10 environment";
      argv = [ "${env.interpreter}" "-m" "ipykernel_launcher" "-f" "{connection_file}" ];
      language = "python";
    };
    haskell = let env = ( pkgs.ghc.withPackages (ghcPkgs: with ghcPkgs; [
      ihaskell
      ghc
    ])); in  {
      compiler = "ghc";
      displayName = "Custom Haskell environment";
      argv = [ "${env}/bin/ihaskell" "kernel" "{connection_file}" "--debug" ];
      #argv = [];
      language = "haskell";
    };

    bash = let env = (pkgs.python311.withPackages (pythonPackages: with pythonPackages; [
      bash_kernel
    ])); in {
      displayName = "Custom bash environment";
      argv = [ "${env.interpreter}" "-m" "bash_kernel" "-f" "{connection_file}" ];
      language = "bash";
    };
  };
  services.jupyter.command = "jupyter-notebook --NotebookApp.allow_remote_access=true --NotebookApp.allow_origin=https://skademaskinen.win:11034 --NotebookApp.base_url=/jupyter/";
}

 
