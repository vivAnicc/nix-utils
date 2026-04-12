{
  inputs = {
    nixpkgs.url = "nixpkgs";
    utils.url = "github:vivAnicc/nix-utils";
  };

  outputs = { utils, nixpkgs, ... }:
    utils.lib.mkFlake (system: let
      pkgs = import nixpkgs {
        inherit system;
      };
      name = "haskell";
    in rec {
      packages.${system}.${name} = devShell.${system};
      
      devShell.${system} = pkgs.haskellPackages.developPackage {
        root = ./.;
        returnShellEnv = true;

        modifier = drv:
          pkgs.haskell.lib.addBuildTools drv [
            pkgs.haskellPackages.cabal-install
            pkgs.haskellPackages.ghcid
          ];
      };
    });
}
