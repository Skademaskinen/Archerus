{pkgs}: let
    name = "SketchBot";
in pkgs.buildDotnetModule {
    name = name;
    pname = name;
    src = pkgs.fetchFromGitHub {
        owner = "Taoshix";
        repo = name;
        rev = "ec25283f78ee91b7ee787119f9c0aca0b1f8dd3a";
        sha256 = "sha256-mqkruofitvf2qXrd/tSUBYQaNbrZ+QokyN9iVmzUFGY=";
    };
    dotnet-sdk = pkgs.dotnet-sdk_8;
    nugetDeps = ./deps.nix;

    projectFile = "${name}/${name}.csproj";

}