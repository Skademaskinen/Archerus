{pkgs ? import <nixpkgs> {}}: let
    name = "SketchBot";
in pkgs.buildDotnetModule {
    name = name;
    pname = name;
    src = pkgs.fetchFromGitHub {
        owner = "Taoshix";
        repo = name;
        rev = "e642da039d4a5f42259a142d8d710f22aeb23d34";
        sha256 = "sha256-EZmpJaGlLXed45YPZl2lIyQYxNV6eQ2tv8Afi7uDW/Y=";
    };
    dotnet-sdk = pkgs.dotnet-sdk_8;
    dotnet-runtime = pkgs.dotnet-runtime_8;
    nugetDeps = ./deps.nix;

    projectFile = "${name}/${name}.csproj";

}
