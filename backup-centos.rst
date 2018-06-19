=======
Back-up
=======

:Autores: Emiliano López (emiliano.lopez@gmail.com)

          Maximiliano Boscovich (maximiliano@boscovich.com.ar)

:Fecha: |date| |time|

.. |date| date:: %d/%m/%Y
.. |time| date:: %H:%M

.. header::
  Curso Administracion GNU/Linux

.. footer::
    ###Page### / ###Total###

En general, un administrador de sistemas se enfrenta a tres tareas para restaurar la funcionalidad completa de un sistema en otro equipo:

- Bootear un sistema de rescate en otro hardware
- replicar la estructura del sistema original
- restaurar archivos del sistema y de usuarios

Mientras que la mayoría de los sistemas de backups resuelven el tercer item, para resolver la primera y segunda opción se recomienda el uso de Relax-and-Recover (*ReaR*), utilidad destinada para recuperar y migrar sistemas (bare metal).

*ReaR* crea un sistema de rescate booteable que permite recuperar el sistema mediante el comando ``rear recover``. Durante este proceso, ReaR replica la estructura de particiones y del sistema de archivos, restaura archivos de sistema y de usuarios (generados por otro sistema de backup) y finalmente instala el cargador de arranque. En su ocpión por defecto, ReaR solo recupera la estructura de particiones y bootloader.

Per además, *ReaR* permite cubir los primeros dos items, con un método ya integrado o bien utilizando algún software de backup externo.

Instalación
===========

.. code:: bash

    yum install rear genisoimage syslinux

Configuración
=============

La configuración de ReaR se realiza en el archivo ``/etc/rear/local.conf`` donde se especifica el formato de la salida y la ubicación. 

Existen dos variables importantes que influyen ReaR: ``OUTPUT`` para definir el método de booteo y ``BACKUP`` para la estrategia de backup.

Sistema
-------

Cuando se usa ``OUTPUT=ISO`` se debe proveer la ubicación del destino en la variable ``OUTPUT_URL``, por ejemplo:

- ``OUTPUT_URL=file://``
    Escribe la imagen ISO en disco, el default es en ``/var/lib/rear/output/``.

- ``OUTPUT_URL=nfs://``
    Escribe la imagen USO usando el protocolo NFS


Datos
-----

Con ``BACKUP`` se define la estrategia de backup y restauración. La más utilizada es ``NETFS``.

``BACKUP=NETFS``

Usa el como método de backup tar o rsync. Cuando usa ``BACKUP=NETFS`` y ``BACKUP_PROG=tar`` existe una opción para seleccionar el tipo de backup, esto es diferencial o incremental, esto se selecciona haciendo ``BACKUP_TYPE=incremental`` o ``BACKUP_TYPE=differential``.

Cuando se usa ``BACKUP=NETFS`` se debe proveer la ubicación del destino en la variable ``BACKUP_URL``, por ejemplo:

- ``BACKUP_URL=file://``
    Hace el backup en disco local, por ej:  ``BACKUP_URL=file:///directory/path/``

- ``BACKUP_URL=nfs://``

    Hace el backup en un recurso compartido por NFS, por ej, ``BACKUP_URL=nfs://nfs-server-name/share/path``


Sistema y datos en una única ISO por NFS
----------------------------------------

Es posible configurar ``ReaR`` para que almacene las imágenes ISO de los backups creados en un servidor NFS remoto.
Para esto se deben configurar al menos los siguientes parámetros:

.. code:: bash

    OUTPUT = ISO
    BACKUP = NETFS
    BACKUP_URL = nfs://IP/RECURSO

Donde ``IP`` es la dirección IP del servidor y ``RECURSO`` el directorio exportado mediante NFS.

Creando sistema de rescate
==========================

.. code:: bash

    rear -v mkrescue

Si se utilizó la opción ``BACKUP=NETFS`` ReaR puede crear un sistema de rescate un backup de archivos o ambos.

- Para crear solamente un sistema de rescate: 

.. code:: bash
    
    rear mkrescue

- Para crear solamente un backup de datos: 

.. code:: bash 
    
    rear mkbackuponly

- Para crear ambos: 

.. code:: bash

    rear mkbackup

Automatizar con crontab
=======================

Especificando en ``/etc/crontab`` se puede programar la generación del sistema de rescate en forma automática. Por ejemplo para que se ejecute a las 22 cada día de semana:

.. code:: bash

    0 22 * * 1-5 root /usr/sbin/rear mkrescue

Restaurando el sistema
''''''''''''''''''''''

- Grabar la imagen generado a un CD/DVD o USB
- Bootear el CD/DVD o USB, loguearse como **root** sin contraseña
- Elegir la opción ``Recover HOSTNAME``
- Ejecutar el comando ``rear recover``


Referencias
===========

https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/deployment_guide/ch-relax-and-recover_rear
https://github.com/rear/rear