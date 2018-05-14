===============
VNC en Centos 7
===============

Antes de comenzar con un servidor de escritorio remoto vamos a ejecutar aplicaciones gráficas a través de ``ssh``. 

``sshd`` (OpenSSH Daemon) provee comunicación cifrada entre dos host sobre una red insegura. Su uso es principalmente para sesiones de terminales remotas, aunque no está limitado a ello. También permite la transferencia de archivos y la ejecución de aplicaciones gráficas remotas. 

Este suele ser muy útil para corroborar accesos a diversos protocolos desde el sistema local, ejecutándo las aplicaciones en forma remota.

**ACTIVIDAD 1.1**

- Transfiera archivos entre diferentes máquinas usando el comando ``scp origen destino``.
- Ejecute la aplicación remota ``firefox`` y ``nautilus`` haciendo uso de ``ssh -X PCRemota comando``.

A continuación veremos el modo de configurar en servidor de escritorios remotos mediante el protocolo VNC.

**Estaría bueno ver este otro: https://www.howtoforge.com/how-to-install-x2goserver-on-centos-7-as-an-alternative-for-vnc** pero parece que no funca con GNOME

Instalación
-----------
Para utilizar el escritorio remoto se debe contar con algún entorno de escritorio. En nuestro caso vamos a utilizar GNOME, cuya instalación se simplifica utilizando la opción ``groupinstall`` del siguiente modo:

.. code-block:: bash

    # yum groupinstall "GNOME Desktop"


y habilitamos el target grafico para que el host por defecto levante el entorno gráfico por defecto

.. code:: bash

   ·# systemctl set-default graphical.target

Luego instalamos el servidor de display remoto:

.. code-block:: bash

    # yum install tigervnc-server

Configuración
-------------
Vamos a crear un servicio que levante el VNC. Para hacer esto en ``systemd`` debemos crear un archivo de configuración llamado ``/etc/systemd/system/vncserver@.service``. Para realizar esta tarea nos basamos en la plantilla por defecto, como root copiamos el archivo ``/usr/lib/systemd/system/vncserver@.service`` del siguiente modo:

.. code-block:: bash

    # cp /usr/lib/systemd/system/vncserver@.service /etc/systemd/system/vncserver@.service

No es necesario incluir el número de display en el nombre del archivo ya que systemd crea automáticamente el nombre de instancia apropiado bajo demanda en memoria, reemplazando el ``%i`` del archivo de servicio por el número de display. Para un único usario no es necesario renombrarlo, para múltiples usuarios se requiere un archivo único por cada usuario requerido (usualmente agregando el nombre de usuario al nombre del archivo). 

Editar ``/etc/systemd/system/vncserver@.service``, reemplazando ``USER`` con el nombre de usuario actual y dejando el resto del archivo sin modificar. El argumento ``-geometry`` especifica el tamañp del escritorio VNC a ser creado, por defecto es 1024x768. Esto sería:

.. code-block:: bash

    ExecStart=/usr/sbin/runuser -l USER -c "/usr/bin/vncserver %i -geometry 1280x1024"
    PIDFile=/home/USER/.vnc/%H%i.pid

 Luego, guarde los cambios y recargue el demonio ejecutando el siguiente comando:

.. code-block:: bash

    # systemctl daemon-reload

Ahora se debe setear la contraseña del usuario para el VNC del siguiente modo:

.. code-block:: bash

    # su - USER
    $ vncpasswd
    Password:
    Verify:

**IMPORTANTE:** La constraseña no se almacena cifrada, cualquiera con acceso al archivo podrá verla en texto plano.

Iniciar el servidor VNC
'''''''''''''''''''''''

Para iniciar o habilitar el servicio se debe espeficar el número de display directamente en el comando. El archivo configurado previamente funcionará como una plantilla donde ``%i`` es sustituído con el número de display por systemd. Ejecute el siguiente comando con un número de display válido:

.. code-block:: bash

    # systemctl start vncserver@:display_number.service

Se debe habilitar el servicio para que se inicie automáticamente:

.. code-block:: bash

    ~]# systemctl enable vncserver@:display_number.service

A partir de esto, otros usuarios podrán conectarse usando un cliente de VNC usando el número de display y su contraseña. Esto proveerá un entorno gráfico diferente al que está corriendo. 

Compartir sesión activa
-----------------------

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
    ExecStart=/usr/bin/sh -c '/usr/bin/x0vncserver -display:0 
        -rfbport 5900 -passwordfile /home/usuario/.vnc/passwd &'

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
-------------------------

No muestra el menú al iniciar un escritorio remoto.

En el repo oficial se encuentra la versión 1.8.0-2 que presenta un bug conocido descripto en
``https://bugzilla.redhat.com/show_bug.cgi?id=1506273``.



Bibliografía
------------

Red Hat Enterprise Linux 7 System Administrator's Guide
