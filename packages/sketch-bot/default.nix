{pkgs ? import <nixpkgs> {}}: let
    name = "SketchBot";
in pkgs.buildDotnetModule {
    name = name;
    pname = name;
    src = pkgs.fetchFromGitHub {
        owner = "Taoshix";
        repo = name;
        rev = "8013adbf744cc79639c6a9ee341d6ae0af19379e";
        sha256 = "sha256-F221KPsd6qbOyEsAYFSwTNPETnjBxblYxDoPu8klRrM=";
    };
    dotnet-sdk = pkgs.dotnet-sdk_8;
    dotnet-runtime = pkgs.dotnet-runtime_8;
    nugetDeps = ./deps.nix;

    projectFile = "${name}/${name}.csproj";

}
