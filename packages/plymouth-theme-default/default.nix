{ lib, ... }:

(lib.load ../plymouth-theme) { logo = lib.wallpapers.flogo; name = "flogo"; }
