{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { nixpkgs, ... }: let
    system = "aarch64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
    stdenv = pkgs.stdenvNoCC;
  in {
    packages.aarch64-linux.default = stdenv.mkDerivation {
      name = "saved-packages";

      buildInputs = import ./packages.nix pkgs;
    };
  };
}
