Vagrant.configure("2") do |config|

  config.vm.box = "opensuse/MicroOS-ContainerHost.x86_64"
  config.vm.box_check_update = false

  config.vm.synced_folder ".", "/vagrant", disabled: 'true'
  config.vm.synced_folder ".", "/home/vagrant/.vagrant",
    :type        => "nfs",
    :nfs_udp     => false,
    :nfs_version => 4

  config.vm.define :a do |a|
    a.vm.hostname = "a"
    a.vm.provider :libvirt do |libvirt|
      libvirt.driver = "kvm"
      libvirt.cpus = 4
      libvirt.cpu_mode = "host-passthrough"
      libvirt.memory = 4048
      libvirt.storage :file,
        :type => "raw",
        :path => "./combustion-a.img"
    end
  end

  config.vm.define :b do |b|
    b.vm.hostname = "b"
    b.vm.provider :libvirt do |libvirt|
      libvirt.driver = "kvm"
      libvirt.cpus = 4
      libvirt.cpu_mode = "host-passthrough"
      libvirt.memory = 4048
      libvirt.storage :file,
        :type => "raw",
        :path => "./combustion-b.img"
    end
  end

  config.vm.boot_timeout = 900

end
