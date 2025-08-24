inputs:

let
    load = import ./utils/load.nix inputs;
in

{
    inherit load;
    capitalize = load ./utils/capitalize.nix;
    removeExtension = load ./utils/removeExtension.nix;
    stringTail = load ./utils/stringTail.nix;
    fetchSteam = load ./utils/fetchSteam.nix;
    mkProject = load ./builders/mkProject.nix;
    mkProxy = load ./builders/mkProxy.nix;
    mkWebProject = load ./builders/mkWebProject.nix;
    mkSubmodules = load ./builders/mkSubmodules.nix;
    mkRecursiveModules = load ./builders/mkRecursiveModules.nix;
    mkBanner = load ./builders/mkBanner.nix;
    mkArchitecture = load ./builders/mkArchitecture.nix;
    mkOptionsHtml = load ./builders/mkOptionsHtml.nix;
    mkWebServer = load ./builders/mkWebServer;
    wallpapers = load ./wallpapers.nix;
    database = load ./utils/database.nix;
} // load ./utils/if.nix
