{
	inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { nixpkgs, ... }: {
    lib = import ./lib.nix nixpkgs;

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
