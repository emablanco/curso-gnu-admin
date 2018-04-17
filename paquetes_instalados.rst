Paquetes instalados
===================

A continuación se listan los paquetes instalados. A los fines de que los alumnos puedan instalarlos por ellos mismos pero que no sea necesario descargarlos de internet, se utiliza el parámetro ``-d`` para el caso de ``yum install`` y, el ``--downloadonly`` para el caso de ``yum groupinstall``.

Primera parte
-------------

.. code-block:: bash

    yum install -d tigervnc-server nfs-utils autofs

Para instalar openvpn primero hay que instalar el repositorio epel:

.. code-block:: bash

    yum install -d epel-release 
    yum install -d openvpn easy-rsa

Para instalar el entorno de escritorio GNOME hay que hacerlo usando ``groupinstall``

.. code-block:: bash

    yum groupinstall "GNOME Desktop" --downloadonly

Segunda parte
-------------