1 - Instalar guest additions en la maquina virtual

2 - Instalar todo lo necesario

3 - Descargar la key insecure de vagrant

.. code:: bash

        wget --no-check-certificate https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub -O /home/vagrant/.ssh/authorized_keys

4 - Llenamos con ceros el espacio libre para que ocupe menos

.. code:: bash

        vagrant ssh
        sudo dd if=/dev/zero of=wipefile bs=1024x1024; rm wipefile

5 - Empaquetamos la instancia con

.. code:: bash

        vagrant package --base debianStretch64TUSL --output debianStretch64TUSL.box

6 - Si deseamos agregar el box localmente

.. code:: bash

        vagrant box add --name debianStretch64TUSL --box-version 1.1 --provider virtualbox debianStretch64TUSL.box

7 - Sino podemos subirlo a vagrantcloud.com
