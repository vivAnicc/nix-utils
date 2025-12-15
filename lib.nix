{ nixpkgs, neovim, nixvim, ... }: let 
  systems = [
   "aarch64-linux"
   "x86_64-linux"
  ];
  lib = nixpkgs.lib;
in rec {
  mkFlake = (fn:
    builtins.foldl' lib.attrsets.recursiveUpdate {} (builtins.map fn systems)
  );

  mkNeovim = (
    {
      system,
      lsp ? [],
      extraPkgs ? [],
      extraConfig ? {},
    }: 
    let
      pkgs = import nixpkgs {inherit system;};
      parsers = lib.mapAttrsToList
        (_: a: a) 
        pkgs.vimPlugins.nvim-treesitter-parsers;
      parsers-pkgs = lib.filter
        lib.isDerivation
        parsers;
      nixvim' = nixvim.legacyPackages.${system};
      lspConfig = builtins.listToAttrs (builtins.map (name: {
        inherit name;
        value.enable = true;
      }) lsp);
      nixvimConfig = lib.recursiveUpdate extraConfig
        (lib.recursiveUpdate neovim.nixvimModules.default {
          lsp.servers = lspConfig;
        });
      nixvimModule = {
        inherit system;
        module = nixvimConfig;
        # extraSpecialArgs = {};
      };
      nvim = nixvim'.makeNixvimWithModule nixvimModule;
    in pkgs.buildEnv {
      name = "nvim";
      paths = parsers-pkgs ++ extraPkgs ++ [nvim, pkgs.ripgrep];
    }
  );

  mkDerivation = ({
      name,
      version ? "v0",
      system ? null,
      packages ? [],
      script,
      src,
    }:
    let
      withSystem = (system:
        let
          pkgs = import nixpkgs {inherit system;};
          paths = packages ++ [
            pkgs.bash
            pkgs.coreutils
          ];
          env = pkgs.buildEnv {
            name = name + "-env";
            inherit paths;
          };
        in derivation {
          inherit name version system;
          builder = "${pkgs.bash}/bin/bash";
          args = [ "-c" (# bash
            ''
              export PATH=${env}/bin:$PATH
              export src=${src}
            '' + script
          )];
        }
      );
    in if system != null
    then withSystem system
    else mkFlake (system: {
      ${system} = withSystem system;
    })
  );
}
