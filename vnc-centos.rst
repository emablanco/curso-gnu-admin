===============
VNC en Centos 7
===============

.. code-block:: bash

    # yum install tigervnc-server

1. A configuration file named ``/etc/systemd/system/vncserver@.service`` is required. To create this file, copy the ``/usr/lib/systemd/system/vncserver@.service`` file as root:

.. code-block:: bash

    # cp /usr/lib/systemd/system/vncserver@.service /etc/systemd/system/vncserver@.service

There is no need to include the display number in the file name because systemd automatically creates the appropriately named instance in memory on demand, replacing '%i' in the service file by the display number. For a single user it is not necessary to rename the file. For multiple users, a uniquely named service file for each user is required, for example, by adding the user name to the file name in some way. 

2. Edit ``/etc/systemd/system/vncserver@.service``, replacing USER with the actual user name. Leave the remaining lines of the file unmodified. The -geometry argument specifies the size of the VNC desktop to be created; by default, it is set to 1024x768.

.. code-block:: bash

    ExecStart=/usr/sbin/runuser -l USER -c "/usr/bin/vncserver %i - geometry 1280x1024" 
    PIDFile=/home/USER/.vnc/%H%i.pid

3. Save the changes. 4. To make the changes take effect immediately, issue the following command:

.. code-block:: bash

    # systemctl daemon-reload

5. Set the password for the user or users defined in the configuration file. Note that you need to switch from root to USER first.

.. code-block:: bash

    # su - USER 
    $ vncpasswd 
    Password: 
    Verify:
    
IMPORTANT: The stored password is not encrypted; anyone who has access to the password file can find the plain-text password

12.1.3. Starting VNC Server

To start or enable the service, specify the display number directly in the command. The file configured above in Procedure 12.1, “Configuring a VNC Display for a Single User” works as a template, in which %i is substituted with the display number by systemd. With a valid display number, execute the following command:

.. code-block:: bash

    # systemctl start vncserver@:display_number.service

You can also enable the service to start automatically at system start. Then, when you log in, vncserver is automatically started. As root, issue a command as follows:

.. code-block:: bash

    ~]# systemctl enable vncserver@:display_number.service

At this point, other users are able to use a VNC viewer program to connect to the VNC server using the display number and password defined. Provided a graphical desktop is installed, an instance of that desktop will be displayed. It will not be the same instance as that currently displayed on the target machine.

Compartir sesión activa
=======================

Por defecto un usuario logueado tiene un escritorio provisto por el servidor X en el display 0. Para compartir una sesión gráfica en ejecución el usuario debe ejecutar el programa ``x0vncserver`` del siguiente modo.

.. code-block:: bash

    x0vncserver -PasswordFile=.vnc/passwd -AlwaysShared=1

Al invocar el comando como se indica previamente, la resolución será la misma que en el escritorio real, sin embargo es posible modificarla usando el parámetro ``-Geometry``, teniendo en cuenta que no acepta mayor resolución a la real. Por ejemplo:

.. code-block:: bash

    x0vncserver -PasswordFile=.vnc/passwd -AlwaysShared=1 -Geometry=640x480+0+0

Tenga en cuenta que debe estar permitido el puerto 5900. El puerto por defecto es el 5900, sin embargo, cada display asignado debe sumarse para conocer el puerto que se utilizará. Por ejemplo, si el display que se sirve es el segundo: 2 + 5900 = 5902.

Para hacer lo mismo como una unidad usando systemd, nos quedaría:

``$ cat /etc/systemd/system/x0vncserver.service``

.. code-block:: bash

    [Unit]
    Description=Remote desktop service (VNC)
    After=syslog.target network.target

    [Service]
    Type=forking
    User=foo
    ExecStart=/usr/bin/sh -c '/usr/bin/x0vncserver -display :0 -rfbport 5900 -passwordfile /home/usuario/.vnc/passwd &'

    [Install]
    WantedBy=multi-user.target

VNC sobre SSH
-------------

Si se desea conectar con **VNC** y que no se envíen los datos en texto plano a través de la red, es posible encapsular los datos en un **túnel SSH**. Sólo hace falta saber que, de forma predeterminada, **VNC** utiliza el puerto *5900* para la primera pantalla (llamada "*localhost:0*"), *5901* para la segunda (llamada "*localhost:1*"), y así sucesivamente.

La orden:

.. code-block:: bash

	ssh -L localhost:5901:localhost:5900 -N -T equipo

crea un **túnel** entre el puerto *local 5901* en la interfaz de "*localhost*" y el puerto *5900* de *equipo* . La primera ocurrencia de "*localhost*" restringe a **SSH** para que sólo escuche en dicha interfaz en la máquina *local*. El segundo "*localhost*" indica que la interfaz en la máquina remota que recibirá el tráfico de red que ingrese en "*localhost:5901*".

Por lo tanto:

.. code-block:: bash

	vncviewer localhost:1

conectará el cliente **VNC** a la pantalla remota aún cuando indique el nombre de la máquina local.

Cuando cierre la sesión **VNC**, también se debe cerrar el **túnel** saliendo de la sesión **SSH** correspondiente.


Bug de la versión 1.8.0-2
=========================

No muestra el menú al iniciar un escritorio remoto.

En el repo oficial se encuentra la versión 1.8.0-2 que presenta un bug conocido descripto en 
``https://bugzilla.redhat.com/show_bug.cgi?id=1506273 ``. 



Bibliografía
============

Red Hat Enterprise Linux 7 System Administrator's Guide
