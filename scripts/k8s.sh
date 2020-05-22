#!/bin/bash

# install kustomize
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash
sudo cp kustomize /usr/local/bin/
sudo chmod a+x /usr/local/bin/kustomize

# clone kubespray repository and install dependencies
git clone -b ${KUBESPRAY_VER} https://github.com/kubernetes-sigs/kubespray.git
sudo chown vagrant.vagrant kubespray -R
cd kubespray

# Install dependencies from ``requirements.txt``
sudo pip3 install -r requirements.txt

# Copy ``inventory/sample`` as ``inventory/mycluster``
cp -rfp inventory/sample inventory/mycluster

# Update Ansible inventory file with inventory builder
declare -a IPS=(192.168.77.21 192.168.77.22 192.168.77.23)
CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}

# Review and change parameters under ``inventory/mycluster/group_vars``

K8S_CLUSTER_YML=inventory/mycluster/group_vars/k8s-cluster/k8s-cluster.yml

# cluster_name
sed -i "s/\(cluster_name\):.*/\1: ${CLUSTER_NAME}/" ${K8S_CLUSTER_YML}

# dns_domain
sed -i "s/\(dns_domain\):.*/\1: ${DNS_DOMAIN}/" ${K8S_CLUSTER_YML}

# kubenetwork_plugin
sed -i "s/\(kube_network_plugin\):.*/\1: ${KUBE_NETWORK_PLUGIN}/" ${K8S_CLUSTER_YML}

# kube_version
sed -i "s/\(kube_version\):.*/\1: ${KUBE_VERSION}/" ${K8S_CLUSTER_YML}

# kubectl configuration
sed -i "s/.*\(kubeconfig_localhost\):.*/\1: true/" ${K8S_CLUSTER_YML}
sed -i "s/.*\(kubectl_localhost\):.*/\1: true/" ${K8S_CLUSTER_YML}

# enable cert_manager
#sed -i "s/\(cert_manager_enabled\):.*/\1: true/" inventory/mycluster/group_vars/k8s-cluster/addons.yml

# Deploy Kubespray with Ansible Playbook - run the playbook as root
# The option `--become` is required, as for example writing SSL keys in /etc/,
# installing packages and interacting with various systemd daemons.
# Without --become the playbook will fail to run!
ansible-playbook -i inventory/mycluster/hosts.yaml --become --become-user=root cluster.yml

# kubectl configuration
mkdir -p ~/.kube
cp inventory/mycluster/artifacts/admin.conf ~/.kube/config
sudo cp inventory/mycluster/artifacts/kubectl /usr/local/bin/kubectl
kubectl config rename-context "kubernetes-admin-k8slab@${CLUSTER_NAME}" ${CLUSTER_NAME}

exit 0
