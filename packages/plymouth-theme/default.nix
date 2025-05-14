inputs:

let

    pkgs = import inputs.nixpkgs { system = inputs.system; };

in pkgs.callPackage (
{ pkgs, lib, logo, ... }:

pkgs.nixos-bgrt-plymouth.overrideAttrs {
    src = pkgs.stdenv.mkDerivation {
        name = "custom-spinner-sources";
        src = pkgs.nixos-bgrt-plymouth.src;
        installPhase = ''
            mkdir -p $out/images
            cp $src/nixos-bgrt.plymouth $out
            cp $src/images/{bullet,capslock,entry,keyboard,keymap-render,lock}.png $out/images
            width=$(${pkgs.imagemagick}/bin/magick identify -format "%w" $src/images/throbber-0001.png)
            height=$(${pkgs.imagemagick}/bin/magick identify -format "%h" $src/images/throbber-0001.png)
            ${builtins.concatStringsSep "\n" (map (index: let 
                angle = index * 12;
                imageIndex = if index < 10 then "000${builtins.toString index}" else "00${builtins.toString index}";
            in "${pkgs.imagemagick}/bin/magick ${logo} -channel RGB -negate +channel -background none -virtual-pixel background -distort SRT ${builtins.toString angle} -resize $((width*2))x$((height*2)) $out/images/throbber-${imageIndex}.png") (lib.lists.range 1 29))}
        '';
    };
})
