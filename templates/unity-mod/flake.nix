{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils = {
      url = "github:vivAnicc/nix-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, utils }: utils.lib.mkFlake (system:
    let
      pkgs = import nixpkgs {inherit system;};
      name = "unity_mod";
      chars = pkgs.lib.stringToCharacters (pkgs.lib.toCamelCase name);
      first = pkgs.lib.toUpper (pkgs.lib.head chars);
      rest = pkgs.lib.drop 1 chars;
      pascal_case_name = pkgs.lib.concatStrings ([first] ++ rest);
    in {
      packages.${system} = {
        default = self.packages.${system}.${name};

        ${name} = derivation {
          inherit name system;
          version = "1.0.0.0";
          builder = "${pkgs.bash}/bin/bash";
          args = [ "-c" #bash
            ''
              ${pkgs.coreutils}/bin/mkdir -p $out/lib
              ${pkgs.coreutils}/bin/cp ${self.packages.${system}."${name}-unwrapped"}/lib/${name}-unwrapped/${pascal_case_name}.dll $out/lib
            ''
          ];
        };

        "${name}-unwrapped" = pkgs.buildDotnetModule {
          pname = name + "-unwrapped";
          version = "1.0.0.0";

          src = ./.;

          projectFile = "${pascal_case_name}.csproj";
          nugetDeps = ./deps.json;

          dotnet-sdk = pkgs.dotnetCorePackages.sdk_9_0;
        };
      };

      devShell.${system} = pkgs.mkShell rec {
        dotnetPkg = pkgs.dotnetCorePackages.combinePackages [
          pkgs.dotnetCorePackages.sdk_9_0
        ];

        deps = [
          pkgs.zlib
          pkgs.zlib.dev
          pkgs.openssl
          dotnetPkg
        ];

        NIX_LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath ([
            pkgs.stdenv.cc.cc
        ] ++ deps);
        NEX_LD = "${pkgs.stdenv.cc.libc_bin}/bin/ld.so";
        nativeBuildInputs = [
        ] ++ deps;

        shellHook = ''
          DOTNET_ROOT="${dotnetPkg}";
        '';
      };
    }
  );
}
