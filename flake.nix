{
	inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { nixpkgs, ... }: {
    lib = {
      mkFlake = (fn:
        let
          systems = [
            "aarch64-linux"
            "x86_64-linux"
          ];
          lib = (import nixpkgs {}).lib;
        in
          builtins.foldl' lib.attrsets.recursiveUpdate {} (builtins.map fn systems)
      );
    };

		templates = {
			zig.path = templates/zig;
			haskell.path = templates/haskell;
		};
	};
}
