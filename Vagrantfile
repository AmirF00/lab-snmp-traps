Vagrant.configure("2") do |config|
  config.vm.provider :libvirt do |libvirt|
    libvirt.driver = "kvm"
    libvirt.memory = 1024
    libvirt.cpus = 1
  end

  config.vm.define "manager" do |manager|
    manager.vm.box = "generic/ubuntu2004"
    manager.vm.network "private_network", ip: "10.0.123.2"
  end

  config.vm.define "agent" do |agent|
    agent.vm.box = "generic/ubuntu2004"
    agent.vm.network "private_network", ip: "10.0.123.3"
  end

  # Your existing provisioning scripts
  config.vm.provision "file", source: "gp2.zip", destination: "/home/vagrant/gp2.zip"
  config.vm.provision "shell", path: "snmp-manager-setup.sh"
  config.vm.provision "shell", path: "snmp-agent-setup.sh"
end
