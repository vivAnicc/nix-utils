{
  inputs = {
    nixpkgs.url = "nixpkgs";
    nix-utils = {
      url = "github:vivAnicc/nix-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nix-utils, nixpkgs }:
    nix-utils.lib.mkFlake (system: let
      pkgs = import nixpkgs {
        inherit system;
        config = {};
      };
      name = "haskell-project";
    in {
      packages.${system} = {
        default = self.packages.${system}.${name};

        ${name} = pkgs.haskellPackages.callCabal2nix name ./. {};
      };
      devShell = pkgs.haskellPackages.shellFor {
        packages = p: [self.packages.${system}.${name}];
        withHoogle = true;
        buildInputs = with pkgs.haskellPackages; [
          haskell-language-server
          ghcid
          cabal-install
        ];
      };
    });
}
