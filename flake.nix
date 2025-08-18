{
  description = "Empty project";

  inputs = {
    devenv-root = {
      url = "file+file:///dev/null";
      flake = false;
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:cachix/devenv-nixpkgs/rolling";
    devenv.url = "github:cachix/devenv";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = inputs@{ nixpkgs, flake-parts, devenv-root, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.devenv.flakeModule
      ];
      systems = nixpkgs.lib.systems.flakeExposed;

      perSystem = { config, self', inputs', pkgs, system, ... }: {
        # NOTE: Unfree packages
        # _module.args.pkgs = import inputs.nixpkgs {
        #   inherit system;
        #   config.allowUnfree = true;
        # };

        devenv.shells.default = {
          name = "Empty project";

          # NOTE: First do devenv shell
          # git-hooks.hooks = {
          #   actionlint =
          #     {
          #       enable = true;
          #       excludes = [ "docker-publish.yaml" ];
          #     };
          #   checkmake.enable = true;
          # };

          devenv.root =
            let
              devenvRootFileContent = builtins.readFile devenv-root.outPath;
            in
            pkgs.lib.mkIf (devenvRootFileContent != "") devenvRootFileContent;

          packages = with pkgs; [
            # hello
          ];
        };
      };
    };
}
