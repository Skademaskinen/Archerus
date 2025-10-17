{ pkgs, lib, ... }:

let
    arcueid = builtins.fetchurl { 
        url = "https://rare-gallery.com/mocahbig/20952-Arcueid-BrunestudArcueid-Brunestud-HD-Wallpaper.png";
        sha256 = "sha256:1qyafdhn64khnzqfwr8pnnvrddzwk9gsv59m7h8cp7s4kvki0vc2";
    };
    kohaku = builtins.fetchurl {
        url = "https://static.wikia.nocookie.net/typemoon/images/a/aa/MeltyBlood_CUT_Kohaku.png";
        sha256 = "sha256:1ni9nlqpx41hm5bqp4bzgap4w0laab7nkij0786psrj35q6vp9k9";
    };
    flogo-repo = builtins.fetchGit {
        url = "https://github.com/Mast3rwaf1z/flogo-spinner";
        rev = "4e995d44febd07cdd41fef466d0404af0e5e3cf0";
    };
    flogo-updated-repo = builtins.fetchGit {
        url = "https://github.com/f-klubben/logo";
        rev = "de1187a9e8c6eb0f42da76d368d84674f7d058c5";
    };
    flogo = "${flogo-repo}/logo_centered.png";

    flogo-inverted = lib.images.build [
        lib.images.invert
        lib.images.cropToContent
    ] flogo;

    flogo-white-background = lib.images.cropToContent "${flogo-updated-repo}/logo-white-circle-background.png";

    fklub = "${flogo-updated-repo}/logo-no-background-with-text.png";

    fklub-padded-filled = lib.images.build [
        (lib.images.fill    "white" )
        (lib.images.pad     20      )
    ] "${flogo-updated-repo}/logo-no-background-with-text.png";
in

{
    inherit arcueid kohaku flogo flogo-inverted fklub fklub-padded-filled flogo-white-background;
}

