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
DEFAULT_BOX_NAME = "bento/ubuntu-22.04"
DEFAULT_BOX_VERSION = "202303.13.0"

kubespray_ver = ENV["KUBESPRAY_VER"] || "v2.24.0"

# control node
ctrlnodes = [
  {
    :hostname => "controller",
    :ip => "192.168.56.10",
    :ram => 2048,
    :cpus => 2,
  }
]

# cluster nodes
nodes = [
  {
    :hostname => "node01",
    :ip => "192.168.56.21",
    :ram => 4096,
    :cpus => 2
  },
#  {
 #   :hostname => "node02",
  #  :ip => "192.168.56.22",
   # :ram => 4096,
   # :cpus => 2
 # },
 # {
   # :hostname => "node03",
   # :ip => "192.168.56.23",
   # :ram => 4096,
   # :cpus => 2
 # },
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

      config.vm.boot_timeout = 900

      config.vm.box = node[:box] ? node[:box] : DEFAULT_BOX_NAME;
      config.vm.box_version = node[:box_version] ? node[:box_version] : DEFAULT_BOX_VERSION;

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

      # ssh public key
      id_rsa_pub = File.read("#{Dir.home}/.ssh/id_rsa.pub")
      config.vm.provision "copy ssh public key", type: "shell",
        inline: "echo \"#{id_rsa_pub}\" >> /home/vagrant/.ssh/authorized_keys"

    end
  end

  # control nodes
  ctrlnodes.each do |ctrl|
    config.vm.define ctrl[:hostname] do |config|
      ### vm definitions ###

      config.vm.hostname = ctrl[:hostname]

      config.vm.boot_timeout = 900

      config.vm.box = ctrl[:box] ? ctrl[:box] : DEFAULT_BOX_NAME;
      config.vm.box_version = ctrl[:box_version] ? ctrl[:box_version] : DEFAULT_BOX_VERSION;

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

      # copy files
      config.vm.provision "file", source: "~/.ssh/id_rsa", destination: "~/.ssh/id_rsa"
      config.vm.provision "shell", inline: <<-SHELL
      chmod 600 /home/vagrant/.ssh/id_rsa
      SHELL
      config.vm.provision "file", source: "./ansible.cfg", destination: "~/.ansible.cfg"

      # kubernetes
      config.vm.provision "k8s", type: "shell", run: "never", privileged: false do |m|
        m.path = "scripts/k8s.sh"
        m.env = {
          "KUBESPRAY_VER" => kubespray_ver
        }
      end

    end
  end
end
