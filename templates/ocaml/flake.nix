{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils = {
      url = "github:vivAnicc/nix-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, utils, self }: utils.lib.mkFlake (system:
    let
      pkgs = import nixpkgs {inherit system;};
      neovim = utils.lib.mkNeovim {
	inherit system;
	extraPkgs = [
	  pkgs.fswatch
	  pkgs.ocamlformat
	];
	lsp = [ "ocamllsp" ];
      };
      name = "ocaml-project";
      version = "0.0.1";
    in {
      packages.${system} = rec {
	${name} = default;

	default = pkgs.ocamlPackages.buildDunePackage {
	  pname = name;
	  inherit version;

	  duneVersion = "3";
	  src = ./ocaml-project;

	  buildInputs = [
	  ];

	  strictDeps = true;
	  preBuild = "dune build ${name}.opam";
	};
      };

      devShells.${system}.default = pkgs.mkShellNoCC {
	packages = [
	  neovim
	  pkgs.opam
	  pkgs.ocamlPackages.utop
	];

	inputsFrom = [
	  self.packages.${system}.${name}
	];
      };
    }
  );
}
