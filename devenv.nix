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
    # Lint shell scripts
    shellcheck.enable = true;

    # Format Terraform files
    terraform-format.enable = true;
    terraform-validate.enable = true;
  };

  # See full reference at https://devenv.sh/reference/options/
}
