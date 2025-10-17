{ pkgs, ... }:

let
    imagemagick = pkgs.imagemagick;

    # mkOp now returns a function: path -> path
    mkOp = cmd: (path: 
        let
            out = pkgs.runCommand "unused" { nativeBuildInputs = [ imagemagick ]; } ''
                convert ${path} ${cmd} $out
            '';
        in out
    );

    # Basic operations
    negate        = mkOp "-negate";
    invert        = mkOp "-channel RGB -negate";
    crop          = format: mkOp "-crop ${format}";
    cropToContent = mkOp "-trim +repage";
    resize        = size: mkOp "-resize ${size}";
    pad           = percent: mkOp "-set option:pad ${toString percent}% -bordercolor none -border ${toString percent}%";
    fill          = color: mkOp "-background ${color} -alpha remove -alpha off";

    toAscii       = width: path: pkgs.runCommand "image.txt" {} ''
        ${pkgs.jp2a}/bin/jp2a --width=${builtins.toString width} "${path}" > $out
    '';

    # build: foldr over ops to compose them
    build = ops: (path:
        pkgs.lib.lists.foldr (op: acc: op acc) path ops
    );

in {
    inherit mkOp build
        negate invert crop cropToContent resize pad fill toAscii;
}

