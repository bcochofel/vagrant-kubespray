# -*- mode: ruby -*-
# vi: set ft=ruby :

# Check for missing plugins
required_plugins = %w(vagrant-hostmanager vagrant-scp vagrant-env)
plugin_installed = false
required_plugins.each do |plugin|
  unless Vagrant.has_plugin?(plugin)
    system "vagrant plugin install #{plugin}"
    plugin_installed = true
  end
end

# If new plugins installed, restart Vagrant process
if plugin_installed === true
  exec "vagrant #{ARGV.join' '}"
end

### configuration parameters ###

# Vagrant variables
VAGRANTFILE_API_VERSION = "2"
DEFAULT_BOX_NAME = "bento/ubuntu-18.04"

kubespray_ver = ENV["KUBESPRAY_VER"] || "v2.13.1"
kube_version = ENV["KUBE_VERSION"] || "v1.17.6"
kube_network_plugin = ENV["KUBE_NETWORK_PLUGIN"] || "calico"
cluster_name = ENV["CLUSTER_NAME"] || "k8slab"
dns_domain = ENV["DNS_DOMAIN"] || "cluster.local"

# control node
ctrlnodes = [
  {
    :hostname => "controller",
    :ip => "192.168.77.10",
    :ram => 2048,
    :cpus => 2,
    :box => "bento/ubuntu-18.04"
  }
]

# cluster nodes
nodes = [
  {
    :hostname => "node01",
    :ip => "192.168.77.21",
    :ram => 4096,
    :cpus => 2
  },
  {
    :hostname => "node02",
    :ip => "192.168.77.22",
    :ram => 4096,
    :cpus => 2
  },
  {
    :hostname => "node03",
    :ip => "192.168.77.23",
    :ram => 4096,
    :cpus => 2
  },
]

### main ###

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # vagrant-hostmanager options
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = false
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  # vagrant-env options
  config.env.enable

  # Forward ssh agent to easily ssh into the different machines
  config.ssh.forward_agent = true

  # cluster nodes
  nodes.each do |node|
    config.vm.define node[:hostname] do |config|
      ### vm definitions ###

      config.vm.hostname = node[:hostname]
      config.vm.box = node[:box] ? node[:box] : DEFAULT_BOX_NAME;
      config.vm.network :private_network, ip: node[:ip]

      memory = node[:ram];
      cpus = node[:cpus];

      ### provider ###

      config.vm.provider :virtualbox do |vb|
        vb.customize [
          "modifyvm", :id,
          "--memory", memory.to_s,
          "--cpus", cpus.to_s,
          "--ioapic", "on",
          "--natdnshostresolver1", "on",
          "--natdnsproxy1", "on"
        ]
      end

      ### provisioners ###

      # preinst
      config.vm.provision "preinst", type: "shell" do |m|
        m.path = "scripts/preinst.sh"
      end

    end
  end

  # control nodes
  ctrlnodes.each do |ctrl|
    config.vm.define ctrl[:hostname] do |config|
      ### triggers ###

      config.trigger.before :up do |trigger|
        trigger.name = "Generate SSH Key pair for controller"
        trigger.run = { path: "scripts/trigger_before.sh" }
      end

      config.trigger.after :up do |trigger|
        trigger.name = "Copy SSH public key to nodes"
        trigger.run = { path: "scripts/trigger_after.sh" }
      end

      ### vm definitions ###

      config.vm.hostname = ctrl[:hostname]
      config.vm.box = ctrl[:box] ? ctrl[:box] : DEFAULT_BOX_NAME;
      config.vm.network :private_network, ip: ctrl[:ip]

      memory = ctrl[:ram];
      cpus = ctrl[:cpus];

      ### provider ###

      config.vm.provider :virtualbox do |vb|
        vb.customize [
          "modifyvm", :id,
          "--memory", memory.to_s,
          "--cpus", cpus.to_s,
          "--ioapic", "on",
          "--natdnshostresolver1", "on",
          "--natdnsproxy1", "on"
        ]
      end

      ### provisioners ###

      # preinst
      config.vm.provision "preinst", type: "shell" do |m|
        m.path = "scripts/preinst.sh"
      end

      # kubernetes
      config.vm.provision "k8s", type: "shell", run: "never", privileged: false do |m|
        m.path = "scripts/k8s.sh"
        m.env = {
          "KUBESPRAY_VER" => kubespray_ver,
          "KUBE_VERSION" => kube_version,
          "KUBE_NETWORK_PLUGIN" => kube_network_plugin,
          "CLUSTER_NAME" => cluster_name,
          "DNS_DOMAIN" => dns_domain
        }
      end

      # terraform
      config.vm.provision "terraform", type: "shell", run: "never", privileged: false do |m|
        m.path = "scripts/terraform.sh"
      end

      # profile
      config.vm.provision "profile", type: "shell", run: "never", privileged: false do |m|
        m.path = "scripts/profile.sh"
      end

    end
  end
end
