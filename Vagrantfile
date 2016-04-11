# -*- mode: ruby -*-
# vi: set ft=ruby :
$coreos_update_channel = "beta"
$coreos_image_version = "899.6.0"
$forwarded_ports = { 3000 => 3000, 8080 => 8080, 8200 => 8200, 4171 => 4171, 4151 => 4151 }

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  config.ssh.insert_key = false

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "coreos-%s" % $coreos_update_channel
  config.vm.box_version = ">= %s" % $coreos_image_version
  config.vm.box_url = "http://%s.release.core-os.net/amd64-usr/%s/coreos_production_vagrant_vmware_fusion.json" % [$coreos_update_channel, $coreos_image_version]

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  $forwarded_ports.each do |guest, host|
    config.vm.network "forwarded_port", guest: guest, host: host, auto_correct: true
  end

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  host_ssh_dir = ENV["HOME"] + "/.ssh"
  config.vm.synced_folder host_ssh_dir, "/home/core/host_ssh", id: "ssh", :nfs => true, :mount_options => ['nolock,vers=3,udp']
  config.vm.synced_folder ".", "/home/core/host", id: "core", :nfs => true,  :mount_options   => ['nolock,vers=3,udp']

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision :file, source: "vagrantfile-user-data", destination: "/tmp/vagrantfile-user-data"
  config.vm.provision :shell, :inline => "mv /tmp/vagrantfile-user-data /var/lib/coreos-vagrant/", :privileged => true
end
