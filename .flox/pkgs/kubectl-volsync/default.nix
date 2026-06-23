{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubectl-volsync";
  version = "0.14.0";

  src = fetchFromGitHub {
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
    mainProgram = "kubectl-volsync";
  };
}
