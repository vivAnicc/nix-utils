{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { nixpkgs, ... }: let
    system = "aarch64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
    pkgToAttr = p: { name = p.name; value = p; };
    pkgsToList = ps: builtins.map pkgToAttr ps;
    packages = import ./packages.nix pkgs;
    pkgList = pkgsToList packages;
    pkgsString = builtins.foldl' (a: b:
      "${a}" + "\n" + "${b}"
    ) "" packages;
  in {
    packages.aarch64-linux.default = derivation ({
      inherit system;
      name = "saved-packages";

      contents = pkgsString;

      builder = "${pkgs.bash}/bin/bash";
      args = ["-c" "echo $contents > $out"];
    } // builtins.listToAttrs pkgList);
  };
}
