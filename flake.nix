{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim = {
      url = "github:vivAnicc/neovim-nvf";
      inputs = {
	nixpkgs.follows = "nixpkgs";
	nvf.follows = "nvf";
      };
    };
  };

  outputs = inputs: {
    lib = import ./lib.nix inputs;

    templates = {
      zig = {
        path = templates/zig;
        description = "Template for a zig project";
      };

      unity-mod = {
        path = templates/unity-mod;
        description = "Template for a unity mod";
      };

      haskell = {
        path = templates/haskell;
        description = "Template for an haskell project";
      };

      ocaml = {
        path = templates/ocaml;
        description = "Template for an OCaml project";
      };
    };
  };
}
