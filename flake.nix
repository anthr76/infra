{
  description = "infra";

  inputs.devshell.url = "github:numtide/devshell";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, flake-utils, devshell, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system: {
      devShell = let
        pkgs = import nixpkgs {
          inherit system;

          overlays = [ devshell.overlay ];
        };
      in pkgs.devshell.mkShell {
        name = "infra";
        packages = with pkgs; [
          kubernetes-helm
          kubie
          ansible
          terraform
          pre-commit
          kubelogin-oidc
          talosctl
          sops
          gh
          fluxcd
          kubectl
        ];
      };
    });
}
