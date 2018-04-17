Creación del box de Centos
##########################

1 - Descargo la iso http://centos.xfree.com.ar/7/isos/x86_64/CentOS-7-x86_64-Minimal-1708.iso

2 - Creo una máquina virtual en virtualbox con 50Gb de disco, 1024Mb de Ram y tipo Redhat 64bits.

3 - Instalo la iso en la VM, y le doy particionado automatica y siguiente siguiente. En la parte de 
configuración de la contraseña de root, le pongo que solo cree un usuario con permisos de administrador (usuario: vagrant, password: vagrant).

4 - Una vez instalada la VM, me logueo y edito el archivo /etc/sysconfig/network-scripts/ifcfg-enp0s3, para cambiar la opción ONBOOT a yes.

5 - Luego reinicio la red 

.. code:: bash

    sudo systemctl restart network
    
6 - Actualizo los paquetes que tiene la instancia

.. code:: bash

    sudo yum update

7 - Instalo las guest additions

.. code:: bash

    sudo yum groupinstall "Development Tools"
    sudo yum install kernel-devel
    sudo yum install epel-release
    sudo yum install dkms
    sudo yum install wget
    wget http://download.virtualbox.org/virtualbox/5.2.10/VBoxGuestAdditions_5.2.10.iso
    sudo mount -o loop VBoxGuestAdditions_5.2.10.iso /mnt/
    sudo /mnt/VBoxLinuxAdditions.run
    sudo umount /mnt/
    rm VBoxGuestAdditions_5.2.10.iso
    sudo reboot
    
8 - Hago un poco de limpieza

.. code:: bash

    sudo yum groupremove "Development Tools"
    sudo yum remove kernel-devel
    sudo yum clean all
    sudo rm -rf /var/cache/yum/
    
9 - Descargo los paquetes necesarios

.. code:: bash
    
    sudo yum install --downloadonly tigervnc-server nfs-utils autofs openvpn easy-rsa
    sudo yum groupinstall "GNOME Desktop" --downloadonly

10 - Genero un par de claves rsa para el que el usuario vagrant se pueda conectar por ssh a este equipo

.. code:: bash

    ssh-keygen
    
11 - Descargo la key insecure, y le pongo permisos 600 al archivo de authorized_keys

.. code:: bash

     wget --no-check-certificate https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub -O /home/vagrant/.ssh/authorized_keys
     chmod 600 /home/vagrant/.ssh/authorized_keys

12 - Creo el directorio /vagrant

.. code:: bash

    sudo mkdir /vagrant 

13 - Agrego al usuario vagrant a los grupos wheel y vboxfs

.. code:: bash

    sudo usermod -a -G wheel vagrant
    sudo usermod -a -G vboxsf vagrant

14 - Modifico el archivo visudo (ejecutamos sudo visudo) y agrego las siguientes líneas

.. code:: bash

    Defaults     env_keep += “SSH_AUTH_SOCK“
    %wheel   ALL=(ALL)     NOPASSWD: ALL

    
15 - Llenamos de cero el espacio libre del disco para que ocupe menos espacio 

.. code:: bash

    sudo dd if=/dev/zero of=wipefile bs=1024x1024; rm wipefile

16 - Salgo de la VM y la apago. Luego desde el equipo anfitrion (host) empaqueto la maquina virtual de virtualbox

.. code:: bash

    vagrant package --base Centos-7-Base --output Centos-7-Base.box

NOTA: La imágen me quedo de 1.2Gb

17 - Agrego el box localmente para probarlo (OPCIONAL)

.. code:: bash

    vagrant box add --name Centos-7-Base --provider virtualbox Centos-7-Base.box

18 - Pruebo crear una maquina a partir de este box, para esto creo un directorio y dentro pongo un archivo llamado Vagrantfile con lo siguiente

.. code:: bash

    # -*- mode: ruby -*-
    # vi: set ft=ruby :
    
    Vagrant.configure("2") do |config|
      config.vm.box = "Centos-7-Base"
      config.vm.provider "virtualbox" do |vb|
        vb.gui = true
        vb.name = "Centos 7 (Vagrant)"
        vb.memory = "1024"
      end
    end



19 - LUego ingreso al directorio y ejecuto vagrant up

.. code:: bash

    vagrant up

20 - Si todo fue bien deberia poder loguearme con vagrant ssh

.. code:: bash
    
    vagrant ssh
    
    