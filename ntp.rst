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

En caso de que se encuentre habilitada la sincronización automática via ntp, y deseamos configurar manualmente la hora, debemos previamente deshabilitar la sincronización automática por medio de ``timedatectl set-ntp false``

**ACTIVIDAD 1**

- Corrobore la zona horaria de su sistema y observe el listado de zonas horarias disponibles
- Modifique manualmente la fecha y hora.

En los sistemas GNU/Linux el protocolo NTP es implementado por un servicio que corre en el espacio de usuario. Este servicio actualiza el reloj del sistema ejecutándose en el kernel. Existen dos alternativas que brindan este servicio *chronyd* y *ntpd*, ambos disponibles desde los repositorios en los paquetes chrony y ntp.

La documentación de Red Hat *recomienda utilizar chrony* en todos los sistemas, salvo en aquellos que por alguna cuestión de compatibilidad sea necesario usar *ntpd*. Ahí se puede encontrar una lista detallada de las diferencias entre uno y otro.

El tráfico NTP se realiza usando paquetes **UDP sobre el puerto 123**.

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

**ACTIVIDAD 2**

- Instale e inicie chrony
- Corrobore la hora del sistema
- Corrobore que el puerto correspondiente se encuentra abierto

El demonio *chronyd* puede ser monitoreado y controlado por la línea de comandos con la utilidad *chronyc*.
Para corroborar que chrony esta sincronizado haga uso de los comandos **tracking**, **sources**, y **sourcestats**.
Para verificar que el servicio se está ejecutando correctamente se ejecuta: ``chronyc tracking``.

.. code-block:: bash

    ~]$ chronyc tracking

.. code-block:: bash
    
    ~]$ chronyc sources

.. code-block:: bash
    
    ~]$ chronyc sourcestats

**ACTIVIDAD 3**

- Haga uso de los comandos tracking, sources y sourcestats y analice su resultado
- Verifique el stratum de su servidor y de aquellos a los que se conecta

Configuración
-------------

El archivo de configuración por defecto es ``/etc/chrony.conf``. Para una lista completa de las directivas que pueden ser utilizadas vea ``https://chrony.tuxfamily.org/manual.html#Configuration-file``.

La configuración mínima para un **cliente** es:

.. code-block:: bash

    pool pool.ntp.org iburst
    driftfile /var/lib/chrony/drift
    makestep 1 3
    rtcsync

La opción ``pool`` indica dónde consultará la lista de servidores cercanos.
El parámetro ``iburst`` es útil para acelerar la sincronización inicial, estos resultados se almacenarán en el ``diftfile``.
La siguiente opción acomodará el reloj si la diferencia de ajuste es mayor a 1 segundo, pero solamente en las primeras 3 actualizaciones. 
La directiva ``rtcsync`` habilita el modo donde la hora del sistema es periódicamente copiada al RTC (real time clock). En GNU/Linux esta copia es realizada por el kernel cada 11 minutos.

La diferencia entre un cliente y un **servidor** es simplemente habilitar la directiva ``allow`` en el archivo de configuración para abrir el puerto (por defecto UDP 123) y permitir a *chronyd* responder a los pedidos de los clientes. ``allow`` sin especificar una red permite el acceso desde cualquier dirección IP. 

Agregando 

.. code-block:: bash
    
    allow 192.0.2.0/24

chronyd será un servidor que aceptará pedidos de la subred ``192.0.2.0/24``.


El archivo de configuración es autoexplicativo sobre cada parámetro, una vez permitida la red se debe reiniciar el servicio:

.. code-block:: bash

    systemctl restart chronyd

**ACTIVIDAD 4**

- Configure **UN ÚNICO** servidor en la LAN
- Configure su pc contra el servidor NTP de la LAN
- Consulte el stratum
- Levante **UN SEGUNDO** servidor que esté sincronizado con el primero
- Configure los restantes clientes con el segundo servidor
- Consulte el stratum


NTPd
====

In order to use ntpd the default user space daemon, chronyd, must be stopped and disabled. Issue the following command as root:

.. code-block:: bash

    ~]# systemctl stop chronyd

To prevent it restarting at system start, issue the following command as root: ~]# systemctl disable chronyd
To check the status of chronyd, issue the following command: 

.. code-block:: bash

    ~]$ systemctl status chronyd

Instalación
-----------

.. code-block:: bash

    yum install ntp

NTP instala el demonio o servicio ntpd, que está contenido en el paquete ``ntp``. Para habilitarlo al incio del sistema:

.. code-block:: bash

    ~]# systemctl enable ntpd

Para comprobar su estado:

.. code-block:: bash

    ~]$ systemctl status ntpd 

Para obtener un breve reporte de estado de ntpd:

.. code-block:: bash

    ~]$ ntpstat 
    unsynchronised 
    time server re-starting 
    polling server every 64 s

El demonio, ntpd, lee el archivo de configuración al inicio del sistema o cuando es reiniciado. La ubicación por defecto es /etc/ntp.conf, observe el contenido del mismo haciendo:

.. code-block:: bash
    
    less /etc/ntp.conf


Referencias
===========

* https://chrony.tuxfamily.org/faq.html
* Red Hat Enterprise Linux 7 System Administrator's Guide