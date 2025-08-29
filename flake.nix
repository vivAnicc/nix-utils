{
	inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { ... }: {
		templates = {
			zig.path = templates/zig;
			haskell.path = templates/haskell;
		};
	};
}
