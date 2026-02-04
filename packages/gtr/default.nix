{ stdenv, inputs, ... }:

stdenv.mkDerivation {
  name = "gtr";
  src = inputs.git-worktree-runner;

  buildPhase = null;

  installPhase = ''
    mkdir -p $out/{lib,bin,adapters,completions}

    cp -R lib/* $out/lib
    cp -R adapters/* $out/adapters
    cp -R completions/* $out/completions
    cp -R bin/* $out/bin
  '';
}
