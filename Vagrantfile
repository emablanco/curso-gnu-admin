# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "mboscovich/Centos7Base"
  config.vm.network "public_network"
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.name = "Centos 7 (Vagrant)"
    vb.memory = "1024"
    vb.customize ["modifyvm", :id, "--usb", "on"]
    vb.customize ["modifyvm", :id, "--usbehci", "off"]
  end
  config.vm.provision "shell", inline: <<-SHELL 	
	IP=$(ip address show enp0s8|grep "inet "|awk '{ print $2 }'|cut -f 1 -d /)   	
	echo "La dirección IP para conectarse a la VM es: $IP"   
  SHELL
end
