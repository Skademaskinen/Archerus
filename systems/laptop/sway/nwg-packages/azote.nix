{pkgs, ...}:
with pkgs.python3Packages;

buildPythonApplication {
    pname = "azote";
    name = "azote";
    src = pkgs.fetchFromGitHub {
        owner = "nwg-piotr";
        repo = "azote";
        rev = "v1.14.1";
        hash = "sha256-HXBzskpCUcIujahY7moIU4DCMhd4nGsdwGqbQHOL4P0=";
    };
    propagatedBuildInputs = [ setuptools ];

    dependencies = [
        pygobject3
        pillow
        pkgs.gtk3
        pkgs.gobject-introspection
    ];
    
    # https://discourse.nixos.org/t/modulenotfounderror-no-module-named-gi/6874/12
    dontWrapGApps = true; # prevent double wrapping
    preFixup = ''
        makeWrapperArgs+=("''${gappsWrapperArgs[@]}") # prevent double wrapping
    '';
}

