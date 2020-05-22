# Create Kubernetes Cluster using Kubespray

[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![GitHub license](https://img.shields.io/github/license/bcochofel/vagrant-kubespray.svg)](https://github.com/bcochofel/vagrant-kubespray/blob/master/LICENSE)
[![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/bcochofel/vagrant-kubespray)](https://github.com/bcochofel/vagrant-kubespray/tags)
[![GitHub issues](https://img.shields.io/github/issues/bcochofel/vagrant-kubespray.svg)](https://github.com/bcochofel/vagrant-kubespray/issues/)
[![GitHub forks](https://img.shields.io/github/forks/bcochofel/vagrant-kubespray.svg?style=social&label=Fork&maxAge=2592000)](https://github.com/bcochofel/vagrant-kubespray/network/)
[![GitHub stars](https://img.shields.io/github/stars/bcochofel/vagrant-kubespray.svg?style=social&label=Star&maxAge=2592000)](https://github.com/bcochofel/vagrant-kubespray/stargazers/)

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

There's also the `profile` provision step that will configure the controller
shell according to [this repo](https://github.com/bcochofel/dotfiles)

## Documentation

- [Requirements](#requirements)
- [References](docs/references.md)

## Requirements

To run this repository you need:

- [Vagrant](https://www.vagrantup.com/downloads.html)
- At least 16GB of RAM (you can change the Vagrantfile)

You can also use [pre-commit](https://pre-commit.com/#install). After installing
`pre-commit` just execute:

```ShellSession
pre-commit install
```

### Some notes

- This uses the following Vagrant plugins (automatically installed):
    - vagrant-hostmanager
    - vagrant-scp
    - vagrant-env
- You can change some variables for kubespray in the `.env` file
