{ pkgs, lib, config, inputs, ... }:

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
