#!/bin/bash

# clone kubespray repository and install dependencies
git clone -b ${KUBESPRAY_VER} https://github.com/kubernetes-sigs/kubespray.git
sudo chown vagrant.vagrant kubespray -R
cd kubespray

# Install dependencies from ``requirements.txt``
sudo pip3 install -r requirements.txt

# Copy ``inventory/sample`` as ``inventory/mycluster``
cp -rfp inventory/sample inventory/mycluster

# Update Ansible inventory file with inventory builder
declare -a IPS=(192.168.56.21 192.168.56.22 192.168.56.23)
CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}

# Review and change parameters under ``inventory/mycluster/group_vars``

K8S_CLUSTER_YML=inventory/mycluster/group_vars/k8s_cluster/k8s-cluster.yml

# kubectl configuration
sed -i "s/.*\(kubeconfig_localhost\):.*/\1: true/" ${K8S_CLUSTER_YML}
sed -i "s/.*\(kubectl_localhost\):.*/\1: true/" ${K8S_CLUSTER_YML}

# enable cert_manager
sed -i "s/\(cert_manager_enabled\):.*/\1: true/" inventory/mycluster/group_vars/k8s_cluster/addons.yml

# Deploy Kubespray with Ansible Playbook - run the playbook as root
# The option `--become` is required, as for example writing SSL keys in /etc/,
# installing packages and interacting with various systemd daemons.
# Without --become the playbook will fail to run!
# ansible-playbook -i inventory/mycluster/hosts.yaml --become --become-user=root cluster.yml
ansible-playbook -i inventory/mycluster/hosts.yaml --become cluster.yml

# kubectl configuration
mkdir -p ~/.kube
cp inventory/mycluster/artifacts/admin.conf ~/.kube/config
sudo cp inventory/mycluster/artifacts/kubectl /usr/local/bin/kubectl

exit 0
