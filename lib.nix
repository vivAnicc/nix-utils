{ nixpkgs, neovim, nvf, ... }: let 
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
      lspConfig = builtins.listToAttrs (map (name: {
        inherit name;
        value.enable = true;
      }) lsp);
      extraModule = lib.recursiveUpdate extraConfig {
	vim.lsp.presets = lspConfig;
      };
      config = nvf.lib.neovimConfiguration {
	inherit pkgs;
	modules = neovim.nvfModules ++ [ extraModule ];
      };
    in pkgs.buildEnv {
      name = "nvim";
      paths = extraPkgs ++ [ config.neovim ];
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
      ${system} = {
        ${name} = withSystem system;
        default = withSystem system;
      };
    })
  );
}
