{ writeShellApplication, patchelf, ... }:

writeShellApplication {
  name = "test-shell";
  runtimeInputs = [
    patchelf
  ];
  checkPhase = "";
  text = builtins.readFile ./test-shell.sh;
}