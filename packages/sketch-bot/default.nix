{pkgs ? import <nixpkgs> {}}: let
    name = "SketchBot";
in pkgs.buildDotnetModule {
    name = name;
    pname = name;
    src = pkgs.fetchFromGitHub {
        owner = "Taoshix";
        repo = name;
        rev = "e0c2db3c137fcea394fd77c78da8083f13196971";
        sha256 = "19nfdni8chqixa5vjzgwhfar7sjkkq0bzyjwkk1jd37fl311n7b7";
    };
    dotnet-sdk = pkgs.dotnet-sdk_8;
    dotnet-runtime = pkgs.dotnet-runtime_8;
    nugetDeps = ./deps.nix;

    projectFile = "${name}/${name}.csproj";

}
