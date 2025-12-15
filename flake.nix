{
	inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    neovim = {
      url = "github:vivAnicc/neovim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, neovim, ... }: {
    lib = import ./lib.nix {inherit nixpkgs neovim;};

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
