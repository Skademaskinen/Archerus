inputs:

let

    pkgs = import inputs.nixpkgs { system = inputs.system; };

in pkgs.callPackage (
{ pkgs, lib, logo, name, ... }:

pkgs.nixos-bgrt-plymouth.overrideAttrs {
    name = "${name}-plymouth";
    src = pkgs.stdenv.mkDerivation {
        name = "custom-spinner-sources";
        src = pkgs.nixos-bgrt-plymouth.src;
        installPhase = ''
            mkdir -p $out/images
            cp $src/nixos-bgrt.plymouth $out/${name}.plymouth
            cp $src/images/{bullet,capslock,entry,keyboard,keymap-render,lock}.png $out/images
            width=$(${pkgs.imagemagick}/bin/magick identify -format "%w" $src/images/throbber-0001.png)
            height=$(${pkgs.imagemagick}/bin/magick identify -format "%h" $src/images/throbber-0001.png)
            ${builtins.concatStringsSep "\n" (map (index: let 
                angle = index * 4;
                imageIndex = if index < 10 then "000${builtins.toString index}" else "00${builtins.toString index}";
            in "${pkgs.imagemagick}/bin/magick ${logo} -channel RGB -negate +channel -background none -virtual-pixel background -distort SRT ${builtins.toString angle} -resize $((width*2))x$((height*2)) $out/images/throbber-${imageIndex}.png") (lib.lists.range 1 29))}
        '';
    };
    installPhase = lib.strings.replaceStrings [
        "nixos-bgrt"
        "runHook postInstall"
    ] [
        name
        ""
    ] pkgs.nixos-bgrt-plymouth.installPhase + ''
        substituteInPlace $out/share/plymouth/themes/${name}/*.plymouth --replace "NixOS BGRT" "${name} BGRT Plymouth Theme"
        substituteInPlace $out/share/plymouth/themes/${name}/*.plymouth --replace "spinning NixOS logo" "Spinning ${name} Logo based on the NixOS BGRT Theme"

        runHook postInstall
    '';
})
