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

      name = "haskell-project";

      opts = {
        root = ./.;
        inherit name;
        withHoogle = true;
      };

      nvim = utils.lib.mkNeovim {
        inherit system;
# hls is somehow broken, so I just don't include it
        # extraPkgs = [ pkgs.haskellPackages.haskell-language-server ];
        # lsp = [ "hls" ];
      };
    in {
      packages.${system} = rec {
        default = pkgs.haskellPackages.developPackage opts;
        ${name} = default;
      };

      devShell.${system} = pkgs.haskellPackages.developPackage (opts // {
        returnShellEnv = true;
        modifier = drv: pkgs.haskell.lib.addBuildTools drv [
          pkgs.haskellPackages.cabal-install
          pkgs.haskellPackages.ghcid
          nvim
        ];
      });
    });
}
