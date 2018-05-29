===
NTP
===

:Autores: Emiliano López (emiliano.lopez@gmail.com)

          Maximiliano Boscovich (maximiliano@boscovich.com.ar)

:Fecha: |date| |time|

.. |date| date:: %d/%m/%Y
.. |time| date:: %H:%M

.. header::
  Curso Administracion GNU/Linux

.. footer::
    ###Page### / ###Total###

El Network Time Protocol (NTP) permite la difusión precisa de la fecha y hora para mantener los relojes de una red de computadoras sincronizados con una referencia común sobre una lan o internet.

Los servidores NTP están clasificados de acuerdo a la distancia a un reloj atómico. Los servidores son pensados como un arreglo en capas o estratos, desde el 1 en la cima, bajando hasta el 15. De aquí que en la jerga suele denominarse con la palabra *stratum* cuando se refiere a una capa específica. Los relojes atómicos son referidos como Stratum 0, sin embargo estos paquetes no se envían a través de la red. La totalidad de los relojes Stratum 0 están incorporados -o conectados- a servidores referidos como Stratum 1. Un servidor que es sincronizado por paquetes marcados como *Stratum N*, pertenece a la categoría siguiente, esto es *Stratum n+1*.

Antes de configurar un cliente/servidor de NTP es necesario tener configurado correctamente la zona horaria, en CentOS se utiliza el comando ``timedatectl``.

Para conocer la zona horaria basta ejecutar ``timedatectl``, mientras que para configurarlo se debe ejecutar ``timedatectl set-timezone ZH`` donde ZH es la zona horaria elegida. Para listar las zonas horarias disponibles se debe ejecutar ``timedatectl list-timezone``. Para más información vea el manual: ``man timedatectl``.

En los sistemas GNU/Linux el protocolo NTP es implementado por un servicio que corre en el espacio de usuario. Este servicio actualiza el reloj del sistema ejecutándose en el kernel. Existen dos alternativas que brindan este servicio *chronyd* y *ntpd*, ambos disponibles desde los repositorios en los paquetes chrony y ntp.

La documentación de Red Hat *recomienda utilizar chrony* en todos los sistemas, salvo en aquellos que por alguna cuestión de compatibilidad sea necesario usar *ntpd*. Ahí se puede encontrar una lista detallada de las diferencias entre uno y otro.

chrony
======

Antes de instalar ``chrony`` debe **asegurarse de tener desinstalado** ``ntp`` y ``ntpdate`` ya que puede causar algunos problemas. Para eliminarlos ejecute:

.. code-block:: bash

    yum remove ntp ntpdate

Luego, se instala *Chrony* haciendo:

.. code-block:: bash

    yum install chrony

To check the status of chronyd, issue the following command:

.. code-block:: bash

    ~]$ systemctl status chronyd

To start chronyd, issue the following command as root:

.. code-block:: bash

    ~]# systemctl start chronyd

To ensure chronyd starts automatically at system start, issue the following command as root: 

.. code-block:: bash

    ~]# systemctl enable chronyd

El demonio *chronyd* puede ser monitoreado y controlado por la línea de comandos con la utilidad *chronyc*.
To check if chrony is synchronized, make use of the **tracking**, **sources**, and **sourcestats** commands.

Checking chrony Tracking To check chrony tracking, issue the following command:

.. code-block:: bash

    ~]$ chronyc tracking

Checking chrony Sources
The sources command displays information about the current time sources that chronyd is accessing. The optional argument -v can be specified, meaning verbose. In this case, extra caption lines are shown as a reminder of the meanings of the columns.

.. code-block:: bash
    
    ~]$ chronyc sources

Checking chrony Source Statistics

The sourcestats command displays information about the drift rate and offset estimation process for each of the sources currently being examined by chronyd. The optional argument -v can be specified, meaning verbose. In this case, extra caption lines are shown as a reminder of the meanings of the columns.

.. code-block:: bash
    
    ~]$ chronyc sourcestats

Para verificar que el servicio se está ejecutando correctamente se ejecuta: ``chronyc tracking``.

Configuración
-------------

El archivo de configuración por defecto es ``/etc/chrony.conf``. Para una lista completa de las directivas que pueden ser utilizadas vea ``https://chrony.tuxfamily.org/manual.html#Configuration-file``.

La diferencia entre un cliente y un servidor es simplemente habilitar la directiva ``allow`` en el archivo de configuración para abrir el puerto (por defecto UDP 123) y permitir a *chronyd* responder a los pedidos de los clientes. ``allow`` sin especificar una red permite el acceso desde cualquier dirección IP. El archivo de configuración es autoexplicativo sobre cada parámetro, una vez permitida la red se debe reiniciar el servicio:

.. code-block:: bash

    systemctl restart chronyd

chronyc
-------

Es posible consultar o cambiar los parámetros de configuración ejecutando algunas de las siguientes opciones una vez dentro del *chronyc*.

NTPd
====