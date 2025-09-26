{ pkgs, ... }:

let
    imagemagick = pkgs.imagemagick;

    mkOp = cmd: name: path:
        pkgs.runCommand name { nativeBuildInputs = [ imagemagick ]; } ''
            convert ${cmd} ${path} $out
        '';

in {
    negate        = mkOp         "-negate";
    invert        = mkOp         "-channel RGB -negate";
    crop          = format: mkOp "-crop ${format}";
    cropToContent = mkOp         "-trim +repage";
    resize        = size: mkOp   "-resize ${size}";
}
