{
  description = "infra devshell";

  inputs.devshell.url = "github:numtide/devshell";
  inputs.flake-parts.url = "github:hercules-ci/flake-parts";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs =
    inputs@{
      self,
      flake-parts,
      devshell,
      nixpkgs
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ devshell.flakeModule ];

      systems = [
        "aarch64-darwin"
        "x86_64-linux"
      ];

      perSystem =
        { pkgs, ... }:
        {
          devshells.default = (
            {
              packages = [
                pkgs.kubectl
                pkgs.just
                pkgs.flux
                pkgs.kns
                pkgs.sops
              ];
            }
          );
        };
    };
}
