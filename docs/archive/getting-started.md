# Getting Started

## Tools needed to operate this repository

#### Feodra

1. Add Terraform Hashicorp repo.

`# dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo`

3. Add rancher copr repo for `kubectl` `helm`.

`# dnf copr enable slaanesh/rancher`

2. Add tools used in this repository.

`# dnf install -y pre-commit kubernetes helm git-crypt ansible dnf-plugins-core terraform python3-devel`

#### General

1. Unlock the repo with your GPG key

`$ git-crypt unlock`

2. Install pre-commit hooks

`$ pre-commit install`
