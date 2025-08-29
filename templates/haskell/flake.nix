{
  inputs.nixpkgs.url = "nixpkgs";
  outputs = { self, nixpkgs }: let
    system = "aarch64-linux";
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
  };
}
