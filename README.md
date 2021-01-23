# Create Kubernetes Cluster using Kubespray

[![pre-commit badge][pre-commit-badge]][pre-commit] [![Conventional commits badge][conventional-commits-badge]][conventional-commits] [![Keep a Changelog v1.1.0 badge][keep-a-changelog-badge]][keep-a-changelog] [![MIT License Badge][license-badge]][license]

This repository will create a Kubernetes Cluster, using Kubespray,
so it can be used for a Lab Environment.

It will create 3 VMs:

- node0[1-3]: 1 k8s master and 2 worker nodes (2 vcpu and 4GB RAM each)
- controller: controller node (2 vcpu, 2GB RAM)

Both `kubectl` and `kustomize` binaries will be installed on the controller
node.

The `Vagrantfile` has a trigger to generate an SSH key pair for the controller
so it can be used with ansible.

This repository was tested using

![Test Env](docs/images/tested.png)

## Quick Start

![Lab Environment](docs/images/lab.png)

Check the variables defined on the `.env` file.

To create the k8s cluster just run:

```ShellSession
vagrant up
vagrant provision --provision-with k8s
```

You can now connect to the controller node and use kubectl using:

```ShellSession
vagrant ssh controller

kubectl cluster-info
```

## Add-ons

You can also install terraform on the controller node using the following command:

```ShellSession
vagrant provision --provision-with terraform
```

You can change terraform version in the `.env` file (or using `TERRAFORM_VER` environment variable)

There's also the `profile` provision step that will configure the controller
shell according to [this repo](https://github.com/bcochofel/dotfiles)

## Documentation

- [Requirements](docs/requirements.md)
- [References](docs/references.md)

## Some notes

- This uses the following Vagrant plugins (automatically installed):
    - vagrant-hostmanager
    - vagrant-scp
    - vagrant-env
- You can change some variables for kubespray in the `.env` file (or using environment variables)

### Environment variables

The following environment variables can be used to overwrite values from `.env` file:

- KUBESPRAY_VER (defaults to 'v2.14.2')
- KUBE_VERSION (defaults to 'v1.18.10')
- KUBE_NETWORK_PLUGIN (defaults to 'calico')
- CLUSTER_NAME (defaults to 'k8slab')
- DNS_DOMAIN (defaults to 'cluster.local')
- TERRAFORM_VER (defaults to '0.14.3')

# pre-commit hooks

Read the [pre-commit hooks](docs/pre-commit-hooks.md) document for more info.

# git-chglog

Read the [git-chglog](docs/git-chlog.md) document for more info.

[pre-commit]: https://github.com/pre-commit/pre-commit
[pre-commit-badge]: https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white
[conventional-commits-badge]: https://img.shields.io/badge/Conventional%20Commits-1.0.0-green.svg
[conventional-commits]: https://conventionalcommits.org
[keep-a-changelog-badge]: https://img.shields.io/badge/changelog-Keep%20a%20Changelog%20v1.1.0-%23E05735
[keep-a-changelog]: https://keepachangelog.com/en/1.0.0/
[license]: ./LICENSE
[license-badge]: https://img.shields.io/badge/license-MIT-green.svg
[changelog]: ./CHANGELOG.md
[changelog-badge]: https://img.shields.io/badge/changelog-Keep%20a%20Changelog%20v1.1.0-%23E05735
