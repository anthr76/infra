{ pkgs, lib, config, inputs, ... }:

let
  kubectl-volsync = pkgs.buildGoModule rec {
    pname = "kubectl-volsync";
    version = "0.14.0";

    src = pkgs.fetchFromGitHub {
      owner = "backube";
      repo = "volsync";
      rev = "v${version}";
      hash = "sha256-vtJlrqbuZ01wo3HRwfSY4RzR5uEKOmNKAmiHIj0CDIU=";
    };

    vendorHash = "sha256-0pU8TruOugV6e+4hKtnJWJ7jGy2Df3Z1bnm6k0XD3tk=";

    subPackages = [ "kubectl-volsync" ];

    ldflags = [
      "-s"
      "-w"
      "-X github.com/backube/volsync/kubectl-volsync/cmd.volsyncVersion=${version}"
    ];

    postInstall = ''
      # Generate shell completions
      mkdir -p $out/share/bash-completion/completions
      mkdir -p $out/share/zsh/site-functions
      mkdir -p $out/share/fish/vendor_completions.d

      $out/bin/kubectl-volsync completion bash > $out/share/bash-completion/completions/kubectl-volsync
      $out/bin/kubectl-volsync completion zsh > $out/share/zsh/site-functions/_kubectl-volsync
      $out/bin/kubectl-volsync completion fish > $out/share/fish/vendor_completions.d/kubectl-volsync.fish
    '';

    meta = with lib; {
      description = "kubectl plugin for VolSync";
      homepage = "https://github.com/backube/volsync";
      license = licenses.agpl3Plus;
    };
  };
in
{
  # https://devenv.sh/basics/
  env.GREET = "Infra Development Environment";
  dotenv.enable = true;

  # https://devenv.sh/packages/
  packages = with pkgs; [
    cilium-cli
    kubectl
    kustomize
    kubernetes-helm
    fluxcd
    google-cloud-sdk
    sops
    age
    just
    cilium-cli
    kns
    kubectl-view-secret
    kubectl-volsync
  ];

  # https://devenv.sh/processes/
  # processes.cargo-watch.exec = "cargo-watch";

  # https://devenv.sh/services/
  # services.postgres.enable = true;

  # https://devenv.sh/scripts/
  scripts.setup-infra.exec = ''
    echo "🚀 Setting up infrastructure development environment..."
    echo ""
    echo "💡 Use 'just --list' to see available automation tasks"
    echo "📚 Check docs/ directory for setup instructions"
  '';

  enterShell = ''
    setup-infra
  '';

  # https://devenv.sh/tasks/
  # tasks = {
  #   "myproj:setup".exec = "mytool build";
  #   "devenv:enterShell".after = [ "myproj:setup" ];
  # };

  # https://devenv.sh/tests/
  enterTest = ''
    echo "🧪 Running infrastructure environment tests..."

    # Test essential tools
    terraform version
    kubectl version --client
    flux version --client
    helm version
    sops --version
    just --version

    # Test cloud CLI tools
    gcloud version

    echo "✅ All tools are working correctly"
  '';

  # https://devenv.sh/git-hooks/
  git-hooks.hooks = {
    shellcheck.enable = true;
    terraform-format.enable = true;
    terraform-validate.enable = true;
    yamllint = {
      enable = true;
      settings.configPath = ".github/lint/.yamllint.yaml";
    };
    trim-trailing-whitespace.enable = true;
    end-of-file-fixer.enable = true;

    # SOPS secret detection
    forbid-secrets = {
      enable = true;
      name = "forbid-secrets";
      entry = "${pkgs.writeShellScript "forbid-secrets" ''
        #!/usr/bin/env bash
        if grep -r "sops:" "$@" 2>/dev/null | grep -v "\.sops\." | grep -qv "\.sops\.yaml"; then
          exit 0
        fi
        for file in "$@"; do
          if [[ "$file" == *.sops.* ]]; then
            continue
          fi
          if grep -q "ENC\[AES256_GCM" "$file" 2>/dev/null; then
            echo "ERROR: Found encrypted SOPS data in non-.sops file: $file"
            exit 1
          fi
          if grep -qE "(PRIVATE KEY|password|secret|api[_-]?key)" "$file" 2>/dev/null; then
            if [[ ! "$file" == *.sops.* ]]; then
              echo "WARNING: Potential secret in $file - verify this is intentional"
            fi
          fi
        done
      ''}";
      types = [ "text" ];
      pass_filenames = true;
    };
  };

  # See full reference at https://devenv.sh/reference/options/
}
