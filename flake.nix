{
	inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixvim.url = "github:nix-community/nixvim";
    neovim = {
      url = "github:vivAnicc/neovim";
      inputs.nixpkgs.follows = "nixpkgs";
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
		};
	};
}
