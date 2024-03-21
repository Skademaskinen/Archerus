{pkgs ? import <nixpkgs> {}}: let
    name = "SketchBot";
in pkgs.buildDotnetModule {
    name = name;
    pname = name;
    src = pkgs.fetchFromGitHub {
        owner = "Taoshix";
        repo = name;
        rev = "69801734762c66967f1a53148d970d68d5e34576";
        sha256 = "sha256-aqNposVOc2droqeaBOAafS3Dd7aFDeV0Wy7pcvueP8Y=";
    };
    dotnet-sdk = pkgs.dotnet-sdk_8;
    dotnet-runtime = pkgs.dotnet-runtime_8;
    nugetDeps = ./deps.nix;

    projectFile = "${name}/${name}.csproj";

}
