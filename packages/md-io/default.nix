{ stdenv }:

stdenv.mkDerivation {
  pname = "MD IO Font";
  version = "0.1.0";
  src = ./fonts;

  buildPhase = null;

  installPhase = ''
    mkdir -p $out/share/fonts
    cp * $out/share/fonts
  '';
}
