{ lib , stdenv , fetchurl }:

stdenv.mkDerivation {
  name = "anyzig";
  

  src = fetchurl {
    url = "https://github.com/marler8997/anyzig/releases/download/v2025_10_15/anyzig-x86_64-linux.tar.gz";
    sha256 = "sha256-JHxS0paC6OeLk6jN/fHeKd512AhAYURa+G/V184dK0A=";
  };

  dontConfigure = true;
  dontBuild = true;

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/bin
    cp zig $out/bin/
  '';

  meta = with lib; {
    description = "One zig to rule them all.";
    platforms = platforms.linux;
  };
}
