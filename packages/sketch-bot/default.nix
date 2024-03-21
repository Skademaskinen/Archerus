{pkgs ? import <nixpkgs> {}}: let
    name = "SketchBot";
in pkgs.buildDotnetModule {
    name = name;
    pname = name;
    src = pkgs.fetchFromGitHub {
        owner = "Taoshix";
        repo = name;
        rev = "8f6c2b951adc3659ba192d0a5463acce046f499d";
        sha256 = "1gg1q72r25pyipf5q3v9p6vammwkyy7g2ny9fw79mlbsxyniswf1";
    };
    dotnet-sdk = pkgs.dotnet-sdk_8;
    dotnet-runtime = pkgs.dotnet-runtime_8;
    nugetDeps = ./deps.nix;

    projectFile = "${name}/${name}.csproj";

}
