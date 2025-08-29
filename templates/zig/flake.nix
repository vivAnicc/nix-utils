{
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

		zig = {
			url = "github:mitchellh/zig-overlay";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		zls = {
			url = "github:zigtools/zls";
			inputs = {
        nixpkgs.follows = "nixpkgs";
        zig-overlay.follows = "zig";
      };
		};

    gitignore = {
			url = "github:hercules-ci/gitignore.nix";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { nixpkgs, zig, zls, gitignore, ... }:
		let
			system = "aarch64-linux";
			pkgs = import nixpkgs {
				inherit system;
				config = {};
			};
			zig-pkg = zig.packages.aarch64-linux.master;
			zls-pkg = zls.packages.aarch64-linux.zls;
      name = "zig-project";
		in {
			devShell.${system} = pkgs.mkShellNoCC {
				packages = [
					pkgs.lldb
					zig-pkg
					zls-pkg
				];
			};

			defaultPackage.${system} = pkgs.stdenvNoCC.mkDerivation {
				inherit name;
				version = "0.0";

				src = gitignore.lib.gitignoreSource ./.;

				nativeBuildInputs = [
					zig-pkg
				];

				dontConfigure = true;
				dontInstall = true;

				buildPhase = ''
					runHook preBuild
          zig build install --global-cache-dir $(pwd)/.cache -Dtarget=${system} -Doptimize=ReleaseSafe --color off --prefix $out
					runHook postBuild
				'';

				checkPhase = ''
					runHook preCheck
					zig build test --global-cache-dir $(pwd)/.cache -Dtarget=${system} -Doptimize=ReleaseSafe --color off
					runHook postCheck
				'';
			};
		};
}
