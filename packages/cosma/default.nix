{ buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "cosma";
  version = "2.5.4";

  src = fetchFromGitHub {
    owner = "graphlab-fr";
    repo = "cosma";
    rev = "${version}";
    sha256 = "sha256-+88rQab1buzPqRlcoxGOckg2PeaRuviU+TECx+qa+gY=";
  };

  env.CYPRESS_INSTALL_BINARY = 0;

  dontNpmBuild = true;

  npmDepsHash = "sha256-GP/vVUHJiBVF9EIGxTBAVfv8qn1C022t7AZEpjeBng8=";
}
