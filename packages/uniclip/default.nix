{ makeWrapper, lib, wl-clipboard, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "uniclip";
  version = "2.3.6";

  src = fetchFromGitHub {
    owner = "quackduck";
    repo = pname;
    rev = "02f28f13455e219deb3c2d0be6352e405bb415ba";
    sha256 = "sha256-K8ssVF1CFgBXsmLso095mq9ZYrFoc78GiloM34FqpeA=";
  };

  nativeBuildInputs = [ makeWrapper ];

  vendorHash = "sha256-ugrWrB0YVs/oWAR3TC3bEpt1VXQC1c3oLrvFJxlR8pw=";

  postFixup = ''
    wrapProgram $out/bin/${pname} \
         --set PATH ${
           lib.makeBinPath [
            wl-clipboard
           ]
         }
  '';
}

