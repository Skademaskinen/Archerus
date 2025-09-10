# this package makes the library "libarcherus"
{ pkgs, ... }:

pkgs.stdenv.mkDerivation {
  pname = "libarcherus";
  version = "0.1.0";

  src = ./.; # your source with headers + cpp files

  nativeBuildInputs = [ pkgs.cmake pkgs.argparse ];
  buildInputs = [ ];

  cmakeFlags = [
    "-DCMAKE_POSITION_INDEPENDENT_CODE=ON"
    "-DBUILD_SHARED_LIBS=ON"
  ];

}
