{ pkgs, lib, ... }:

let
    arcueid = builtins.fetchurl { 
        url = "https://rare-gallery.com/mocahbig/20952-Arcueid-BrunestudArcueid-Brunestud-HD-Wallpaper.png";
        sha256 = "sha256:1qyafdhn64khnzqfwr8pnnvrddzwk9gsv59m7h8cp7s4kvki0vc2";
    };
    flogo = "${builtins.fetchGit {
        url = "https://github.com/Mast3rwaf1z/flogo-spinner";
        rev = "4e995d44febd07cdd41fef466d0404af0e5e3cf0";
    }}/logo_centered.png";
    flogo-inverted = lib.images.cropToContent (lib.images.invert flogo);
in

{
    inherit arcueid flogo flogo-inverted;
}

