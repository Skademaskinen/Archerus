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

    ciel-big = builtins.fetchurl {
        url = "https://junktheeater.wordpress.com/wp-content/uploads/2021/07/e3808ce69c88e5a7ab-a-piece-of-blue-glass-moon-e3808de7acac3e5bcbepv-loz0ewjxmes.mkv_snapshot_00.48.130.jpg";
        sha256 = "sha256-7Cx9oYooRmCRz/XajUMkwhSFreIjyDjSkrTI9Rnb9BU=";
    };
    ciel = builtins.fetchurl {
        url = "https://static.wikia.nocookie.net/murderseries/images/8/87/Ciel.png";
        sha256 = "sha256-7u/g4Wu+EAYIT+6R3q2M7S/o2qpWugv6EwIjrCP7fv8=";
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
    inherit arcueid kohaku ciel-big ciel flogo flogo-inverted fklub fklub-padded-filled flogo-white-background;
}

